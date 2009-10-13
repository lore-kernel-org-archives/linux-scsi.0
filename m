From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings
Date: Mon, 12 Oct 2009 21:19:56 -0700
Message-ID: <20091013041956.0f8048d8@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail142.messagelabs.com ([216.82.249.99]:16143 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZJMEUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 00:20:55 -0400
In-Reply-To: 4AD3F01F.8080703@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

I have put in that code as infrastructure needed when we implement
the blob that we had discussed. Yes, it needs the changes in scsi_transport_iscsi
,then, I will call the mgmt_fw_cmd

----- Original Message -----
From: Mike Christie
[mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal
[mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org
Sent:
Mon, 12 Oct 2009 20:12:31 -0700
Subject: Re: [PATCH 1/1] be2iscsi: Enabling
MSIX and mcc_rings


> Jayamohan Kallickal wrote:
> >    This patch adds
> > 
> > 1) Turns on msix
> > 2) mcc_ring support for sending FW commands
> > 3) Support for Ring Mode of WRB Posting
> 
> 
> 
> >  
> > +struct be_mgmt_fw_cmd_info {
> > +	struct be_cmd_req_hdr hdr;
> > +	void   *pdata_buffer;
> > +	unsigned int data_length;
> > +} __packed;
> > +
> > +struct be_mgmt_fw_cmd_info_resp {
> > +	struct be_cmd_resp_hdr hdr;
> > +	void   *pdata_buffer;
> > +	unsigned int data_length;
> > +} __packed;
> > +
> > +
> 
> Did you meant to send another patch with this one or did you not mean to 
> include the mgmt_fw code in here? be_mgmt_fw_cmd_info_resp is not used 
> and be_mgmt_fw_cmd_info is used in mgmt_fw_cmd, but that function is 
> never called.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

