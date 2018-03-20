From: okaya@codeaurora.org
Subject: Re: [PATCH v4 3/7] scsi: dpt_i2o: eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 08:13:30 -0400
Message-ID: <fe8fe164a7b3c4372c3e12d43a6e48c2@codeaurora.org>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
 <1521514207-10695-4-git-send-email-okaya@codeaurora.org>
 <20180320102304.GA21265@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320102304.GA21265@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-03-20 06:23, Christoph Hellwig wrote:
> This is a basically unmaintained driver for historic hardware, and not 
> the
> right place for micro-optimizations.

Sure, I can drop this on the next version.
