From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - sd vs. sg Devices, and Low-level Driver.
Date: Mon, 19 Apr 2004 18:39:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFB2@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:49632 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S261263AbUDSXjy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 19:39:54 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

These are newbi questions on sd and sg devices and low-level SCSI driver.  Any information would be appreciated.

Q1:
When the low-level SCSI driver registers a physical disk, which parameters (in scsi_device or some other structs?) decide this physical disk will be registered/presented as a sd or sg device and how?  I presume the low-level driver makes the decision which type of device (sd or sg) the physical disk is registered/presented as, but I can be wrong.

Q2:
>From low-level driver coding/maintenance point of view, which one is easier, registering/presenting a physical disk as a sd or sg device?

Many thanks,


Lee

