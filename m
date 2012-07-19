From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Thu, 19 Jul 2012 08:28:01 +0100
Message-ID: <1342682881.3059.3.camel@dabdike.int.hansenpartnership.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	 <20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com>
	 <1342561819.18004.470.camel@haakon2.linux-iscsi.org>
	 <5006BD3D.7090104@us.ibm.com> <20120718155338.GA21817@infradead.org>
	 <5006DDAA.6080304@us.ibm.com>
	 <1342630038.3022.111.camel@dabdike.int.hansenpartnership.com>
	 <50070A8D.7020203@us.ibm.com> <5007A28C.602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5007A28C.602@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-19 at 08:00 +0200, Paolo Bonzini wrote:
> Il 18/07/2012 21:12, Anthony Liguori ha scritto:
>  Windows does this with a points system and I do believe that INQUIRY
> > responses from any local disks are included in this tally.
> 
> INQUIRY responses (at least vendor/product/type) should not change.

INQUIRY responses often change for arrays because a firmware upgrade
enables new features and new features have to declare themselves,
usually in the INQUIRY data.  What you mean, I think, is that previously
exposed features in INQUIRY data, as well as strings
(vendor/product/type, as you say), shouldn't change, but unexposed data
(read 0 in the fields) may.

James


