From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] vhost/scsi: Add ANY_LAYOUT support
Date: Mon, 2 Feb 2015 00:15:25 -0800
Message-ID: <20150202081525.GA7264@infradead.org>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422605552-24797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

Al has been rewriting the vhost code to use iov_iter primitives,
can you please rebase it on top of that istead of using the obsolete
infrastructure?
