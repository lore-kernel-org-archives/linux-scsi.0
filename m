From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - max_channel, max_id and max_lun
Date: Tue, 1 Jun 2004 13:21:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF016@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:4123 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S265107AbUFASVo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 14:21:44 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

In scsi_register( ) defined in hosts.c of lk 2.4, it says:

    /* These three are default values which can be overridden */
    retval->max_channel = 0; 
    retval->max_id = 8;      
    retval->max_lun = 8;

Just wondering where is the right place to modify max_channel, max_id and max_lun in a low-level driver?

After low-level driver invokes scsi_register(Scsi_Host_Template *, int), we can get a pointer to Scsi_Host that contains max_channel, max_id and max_lun.  However, I can't see how these numbers take effect if we modify them after scsi_register( ) returns.  I assume we need to pass those numbers to mid-layer when invoking scsi_register( ), but Scsi_Host_Template doesn't contain those three numbers.

The reason I want to modify those three numbers is that I need scan_scsis( ) defined in scsi_scan.c of lk2.4 to scan certain numbers of buses, targets and luns I choose.

Thanks,


Lee


