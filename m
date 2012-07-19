From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Thu, 19 Jul 2012 09:30:51 +0200
Message-ID: <5007B7AB.6060906@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com>
	<1342561819.18004.470.camel@haakon2.linux-iscsi.org>
	<5006BD3D.7090104@us.ibm.com>
	<20120718155338.GA21817@infradead.org>
	<5006DDAA.6080304@us.ibm.com>
	<1342630038.3022.111.camel@dabdike.int.hansenpartnership.com>
	<50070A8D.7020203@us.ibm.com> <5007A28C.602@redhat.com>
	<1342682881.3059.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1342682881.3059.3.camel@dabdike.int.hansenpartnership.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Il 19/07/2012 09:28, James Bottomley ha scritto:
>> > INQUIRY responses (at least vendor/product/type) should not change.
> INQUIRY responses often change for arrays because a firmware upgrade
> enables new features and new features have to declare themselves,
> usually in the INQUIRY data.  What you mean, I think, is that previously
> exposed features in INQUIRY data, as well as strings
> (vendor/product/type, as you say), shouldn't change, but unexposed data
> (read 0 in the fields) may.

What I meant is that it's unlikely that Windows fingerprinting is using
anything but vendor/product/type, because everything else can change.

Paolo
