From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: 13 Jul 2004 09:27:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089728842.2055.11.camel@mulgrave>
References: <20040712140558.GA6961@praka.san.rr.com>
	<1089668486.1799.62.camel@mulgrave>  <40F32AAE.5070508@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13227 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265237AbUGMO1p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 10:27:45 -0400
In-Reply-To: <40F32AAE.5070508@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net, Krishna Murthy <krmurthy@cisco.com>

On Mon, 2004-07-12 at 19:19, Mike Christie wrote:
> Depending on the API, we might be able to use it for the linux-iscsi 
> driver. Today the driver uses scsi_activate_tcq(), but does not uses the 
> tag numbers. Instead it uses its own initiator task tags values for 
> session wide identifiers, becuase we need tag values for iscsi ops. For 
> example if we need to send a ping how should we get a tag from the mid 
> layer? Or maybe becuase there are some transport specific tag values 
> should we use someting else or keep it in the driver?

The only clean way I can see of doing it is to store the tags map in the
host structure.  That will pretty much require one host per transport
end point.  Is the iSCSI driver moving in that direction?

James


