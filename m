From: rick.brown@oit.gatech.edu
Subject: Re: more arrays for scsi_dh_rdac.c
Date: Tue, 11 Aug 2009 12:42:49 -0400 (EDT)
Message-ID: <1207023377.1407581250008969161.JavaMail.root@mail6.gatech.edu>
References: <1451868482.1406871250008816057.JavaMail.root@mail6.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deliverator5.ecc.gatech.edu ([130.207.185.175]:57000 "EHLO
	deliverator5.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbZHKQmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 12:42:54 -0400
In-Reply-To: <1451868482.1406871250008816057.JavaMail.root@mail6.gatech.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Babu Moger <Babu.Moger@lsi.com>
Cc: sekharan@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Doh!  Yes indeed, the 2nd string should read {"SUN", "CSM100_R_FC"}

----- "Babu Moger" <Babu.Moger@lsi.com> wrote:

> From: "Babu Moger" <Babu.Moger@lsi.com>
> To: "rick brown" <rick.brown@oit.gatech.edu>, linux-scsi@vger.kernel.org
> Cc: sekharan@linux.vnet.ibm.com
> Sent: Tuesday, August 11, 2009 12:30:33 PM GMT -05:00 US/Canada Eastern
> Subject: RE: more arrays for scsi_dh_rdac.c
>
> Rick, 
> Looks like Chandra is going to add these strings in scsi_dh_rdac.c.
> 
> Can you please confirm the second string? Shouldn't it be read as
> {"SUN", "CSM100_R_FC"}?
>    
> 
> Thanks
> Babu Moger 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of rick.brown@oit.gatech.edu
> > Sent: Tuesday, August 11, 2009 8:38 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: more arrays for scsi_dh_rdac.c
> > 
> > Please consider adding the following two devices to the devlist in
> > scsi_dc_rdac.c
> > 
> > {"STK", "FLEXLINE 380"},
> > {"SUN", "CSM_100_R_FC"},
> > 
> > The Flexline 380 is also now known as the Sun StorageTek 6540, and
> the
> > CSM_100_R_FC is also known as the Sun StorEdge 6130 - both are
> rebranded
> > LSI arrays.
> > 
> > --
> > Rick Brown
> > Office of Information Technology
> > Georgia Institute of Technology
> > 258 4th Street N.W.  Atlanta, GA  30332-0715
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Rick Brown
Office of Information Technology
Georgia Institute of Technology
258 4th Street N.W.  Atlanta, GA  30332-0715
rick@gatech.edu
(404) 894-6175
