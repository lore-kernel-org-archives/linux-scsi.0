From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Wed, 9 Jul 2014 01:44:53 -0700
Message-ID: <20140709084453.GG6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-7-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
> Windows host require this.

What are IHV drivers?


Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
