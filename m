From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 3/7] scsi: dpt_i2o: eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 03:23:04 -0700
Message-ID: <20180320102304.GA21265@infradead.org>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
 <1521514207-10695-4-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521514207-10695-4-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a basically unmaintained driver for historic hardware, and not the
right place for micro-optimizations.
