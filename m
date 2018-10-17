From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi/sd: Avoid that hibernation triggers a kernel
 warning
Date: Wed, 17 Oct 2018 15:53:47 -0700
Message-ID: <1539816827.129692.27.camel@acm.org>
References: <20181017202719.137168-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181017202719.137168-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.com>, Luis Chamberlain <mcgrof@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-10-17 at 13:27 -0700, Bart Van Assche wrote:
+AD4 Although the power management code never calls the system-wide and runtime
+AD4 suspend callbacks concurrently, runtime power state changes can happen
+AD4 while the system is being suspended or resumed. See also the dpm+AF8-suspend()
+AD4 and dpm+AF8-resume() calls in hibernation+AF8-snapshot(). Make sure the sd driver
+AD4 supports this. This patch avoids that the following call trace is reported
+AD4 during system-wide suspend +AFs ... +AF0

This patch does not apply cleanly on Martin's 4.20/scsi-queue tree. I will
rebase this patch, retest and repost it.

Bart.
