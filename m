From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: /proc/scsi/map
Date: Mon, 17 Jun 2002 08:55:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D5D@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Sancho Dauskardt <sancho@dauskardt.de>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net

>From an infiniband point of view, this sounds great!

--
Michael Heinz
Infinicon Systems, Inc.
http://www.infiniconsys.com 

> -----Original Message-----
> From: Sancho Dauskardt [mailto:sancho@dauskardt.de]
> Sent: Saturday, June 15, 2002 3:50 PM
> To: Kurt Garloff; Linux kernel list; Linux SCSI list
> Cc: linux-usb-devel@lists.sourceforge.net;
> linux1394-devel@lists.sourceforge.net
> Subject: Re: /proc/scsi/map
> 
> 
> 
> >Life would be easier if the scsi subsystem would just report 
> which SCSI
> >device (uniquely identified by the 
> controller,bus,target,unit tuple) belongs
> >to which high-level device. The information is available in 
> the kernel.
> >
> >Attached patch does this:
> >garloff@pckurt:/raid5/Kernel/src $ cat /proc/scsi/map
> ># C,B,T,U       Type    onl     sg_nm   sg_dev  nm      dev(hex)
> >0,0,00,00       0x05    1       sg0     c:15:00 sr0     b:0b:00
> [...]
> 
> Great, this was really missing badly.
> 
> But how about adding another column: GUID.
> Most usb-storage and (all?) FireWire devices have such a 
> unique identitiy.
> In contrast to native SCSI devices, these emulated SCSI devices on 
> hot-plugging busses will change their LUNs/IDs. Therefor the 
> GUID is really 
> a must to be able to create stable names (laptop suspend, etc.).
> 
> Both usb-storage and iee1394-sbp2 know the GUID. It only needs to be 
> communicated..
> 
> I'd guess that FibreChannel has similar problems ?
> 
> - sda
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
