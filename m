From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V6 0/5] Add XEN pvSCSI support
Date: Mon, 1 Sep 2014 18:11:22 +0100
Message-ID: <5404A8BA.1090602@citrix.com>
References: <1409201053-6223-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1409201053-6223-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org, konrad.wilk@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 28/08/14 05:44, Juergen Gross wrote:
> This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
> SCSI devices from a XEN domain.

Applied to devel/for-linus-3.18.

Thanks.

Your lines in your descriptions were too long for the default git log
format.  I fixed this up but can you ensure they're wrapped at 72
characters next time.  Also Xen isn't an abbreviation and should not be
capitalized.

David
