From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: LED trigger for UFS device activity
Date: Mon, 1 Oct 2018 18:56:00 +0530
Message-ID: <20181001132600.GA27931@mani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello everyone,

I'm looking into adding LED trigger support for UFS device activity. This
essentially means a dedicated LED will blink upon the UFS device activity
like we have for ATA, MTD, NAND devices.

Currently, I'm not sure about the places where we have to insert this trigger.
My only choice so far is to add the trigger in `ufshcd_send_command` API,
which sends the SCSI/device management commands to the hardware.

Is there any other places where we should insert the trigger? Before that, is
this feature be acceptable?

Looking forward to the responses!

Thanks,
Mani
