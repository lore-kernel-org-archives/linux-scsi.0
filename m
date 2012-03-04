From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
 the host
Date: Sun, 4 Mar 2012 04:12:25 -0500
Message-ID: <20120304091225.GA27297@infradead.org>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1330721347-26781-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> Windows hosts don't handle the ATA_16 command; don't pass it to the host.

Most devices don't handle it, and answer with and unsupported opcode
sense reason.  If hyperv iis buggy enough to crap out on it please add
a comment explaining that.
