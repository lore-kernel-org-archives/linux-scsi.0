From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: FW: new driver
Date: Tue, 17 Feb 2004 10:51:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9235@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57517 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266237AbUBQPwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 10:52:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kschneider@bout-tyme.net, arjanv@redhat.com
Cc: "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Jarrett, Peter B." <Peterj@lsil.com>

I don't believe LSI Logic has opened
sourced the MegaRAID IDEAL driver for inclusion
into the generic kernel.
If it has, its probably best to let this effort
be driven by Atul Mukker<atulm@lsil.com>.

To my knowledge, this is a SCSI LLD in which 
both the low-level hardware driver and 
software raid are one driver.  There was
an effort I started to open source some of
the driver, which was linked to a pre-compiled
library. I'm not sure of the current status
as its been over a year since my involvement. 

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/




On Saturday, February 14, 2004 5:06 PM, Ken Schneider wrote
> 
> I have been sent the sources for the LSI LOGIC, Inc. Ultra 
> ATA100 IDE raid 
> controller as found on the mainboard of the HP ML330 
> computer. I requested 
> information concerning the inclusion of the code into the 
> kernel tree and 
> have been informed that the source is open and can be 
> included as stated in 
> all of the .c and .h files.
> Example:
> 
> /*
>  * Linux MegaRAID IDEal Software RAID Stack
>  * Copyright (c) 2003 LSI Logic Corporation
>  
> *-------------------------------------------------------------
> ----------------
>  *
>  *  This program is free software; you can redistribute it 
> and/or modify
>  *  it under the terms of the GNU General Public License as 
> published by
>  *  the Free Software Foundation; either version 2 of the License, or
>  *  (at your option) any later version.
>  *
>  *  This program is distributed in the hope that it will be useful,
>  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  *  GNU General Public License for more details.
>  *
>  *  You should have received a copy of the GNU General Public License
>  *  along with this program; if not, write to the Free Software
>  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  *
>  
> *-------------------------------------------------------------
> ----------------
>  */
> 
> Having this code included will make the life of many people 
> much easier in 
> being able to use the raid function of the controller.
> 
> I have been able (with the help of people on the SuSE mailing 
> list) to get the 
> module compiled for the 2.4 kernel. As the 2.6 tree and compilation 
> procedures have changed I can no longer get the module to 
> compile, I am not a 
> programmer as I know just enough about C to be dangerous.
> 
> Copies of the correspondence and the sources are available 
> either from me or 
> tech support at LSI Logic Corp. 
> 
> Any help in this matter would be appreciated. I am also 
> willing to be a guinea 
> pig for any testing of the module.
> 
> Ken Schneider
> 
> kschneider@bout-tyme.net
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
