From: "Haofeng Kou" <haofengk@ptu.promise.com>
Subject: SCSI Command scatter-gather number
Date: Tue, 30 Jul 2002 14:07:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For the "struct scsi_cmnd", there is a member :
	unsigned short use_sg;
Which gives the Number of pieces of the scatter-gather.

How to limit its value, how to set the max value for the "use_sg"?


Thanks,
