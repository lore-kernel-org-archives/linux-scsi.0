From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol
 dependency
Date: Fri, 16 Dec 2016 00:17:12 -0800
Message-ID: <20161216081712.GB13847@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
 <20161214211823.GC14133@infradead.org>
 <8A5A0387-B871-4E64-9439-5C936947E1F8@cavium.com>
 <323E0F97-56EE-4EB4-A204-B824BDE8B1D5@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <323E0F97-56EE-4EB4-A204-B824BDE8B1D5@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: "Tran, Quinn" <Quinn.Tran@cavium.com>
Cc: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, Christoph Hellwig <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 15, 2016 at 08:50:39PM +0000, Tran, Quinn wrote:
> Christoph,
> 
> Qlogic was asked to support other Target Stack (SC ST) using the same qla2xxx.ko upstream driver.  I had mentioned this during the last 2015 LSF get together.  Hopefully, that gives a better context.  The understanding that came away was “Qlogic do what is needed to provide this support without creating any dead code”.

Right.  And what you're doing here is to create tons of pointless and
dead code.  If you can support something else without clearly making the
in-kernel version worse it's all fine.  This patch on the other hand is
complete crap and totally unacceptable in this form.
