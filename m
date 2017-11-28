From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi: arcmsr: Add driver module parameter
 msi_enable
Date: Tue, 28 Nov 2017 05:58:55 -0800
Message-ID: <20171128135855.GA24390@infradead.org>
References: <1511832524.4399.20.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511832524.4399.20.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 28, 2017 at 09:28:44AM +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
> 
> Add module parameter msi_enable to has a chance to disable msi interrupt if between controller and system has
> msi INT compatible issue.

If there is a system issue the system will need a quirk, and not every
driver.
