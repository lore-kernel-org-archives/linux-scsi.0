From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings
Date: Tue, 13 Oct 2009 17:45:04 -0500
Message-ID: <4AD502F0.8060600@cs.wisc.edu>
References: <20091013041956.0f8048d8@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47054 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910AbZJMWps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:45:48 -0400
In-Reply-To: <20091013041956.0f8048d8@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

On 10/12/2009 11:19 PM, Jayamohan Kalickal wrote:
> I have put in that code as infrastructure needed when we implement
> the blob that we had discussed. Yes, it needs the changes in scsi_transport_iscsi
> ,then, I will call the mgmt_fw_cmd
>

Ah ok. You will not want to include it with this patch then. Include the 
mgmt stuff when you are sending the other code.
