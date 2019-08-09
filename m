From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] scsi: sym53c8xx_2: remove redundant assignment to retv
Date: Fri, 9 Aug 2019 11:17:33 -0700
Message-ID: <20190809181733.GQ5482@bombadil.infradead.org>
References: <20190809175932.10197-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190809175932.10197-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 09, 2019 at 06:59:32PM +0100, Colin King wrote:
> Variable retv is initialized to a value that is never read and it
> is re-assigned later. The initialization is redundant and can be
> removed.

Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Seems like a bit of a pointless class of warnings, given that gcc now
initialises all locals.  But I'm happy for James or Martin to pick it up.
