From: <Menny_Hamburger@Dell.com>
Subject: Question regarding timeout handling in scsi_io_completion
Date: Sun, 28 Sep 2014 15:36:31 +0100
Message-ID: <D8C50530D6022F40A817A35C40CC06A70D04655FA1@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxipps301.us.dell.com ([143.166.148.223]:48780 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaI1Oge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2014 10:36:34 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

A recent patch added a timeout into scsi_io_completion in order to avoid infinite command retries.
In the case where we have a failed device and the device cannot recover from the error state:
If in this case 'error' is left as 0, could this cause issues in the DM layer (mpath for example), which does not mark the device as failed and continues to queue requests?

Thanks
