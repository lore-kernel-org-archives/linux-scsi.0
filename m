From: "Jansen, Frank" <fjansen@egenera.com>
Subject: RE: Persistent Reservation
Date: Thu, 16 Nov 2006 08:46:08 -0500
Message-ID: <216D6FA68B0F304DA93E95C5B786F2D17C8439@bart.corp.egenera.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:24029 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S933501AbWKPNsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2006 08:48:20 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djshetty <dhirajshetty.junk@mailnull.com>, linux-scsi@vger.kernel.org

Dhiraj,

In the most common case, persistent reservations are stored with the
device, such as the storage array.  Note that not all devices
implement/support persistent reservations and there are cases where the
reservations are stored elsewhere, which tends to be the approach in
virtualizing environments.

Regards,

Frank

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of djshetty
> Sent: Thursday, November 16, 2006 7:27 AM
> To: linux-scsi@vger.kernel.org
> Subject: Persistent Reservation
> 
> 
> Hi,
> 
> I had a doubt. In order to persist the reservation we need to 
> store some information like reservation keys, scope, type of 
> reservation etc.
> 
> Where exactly are such information stored and by whom ?
> 
> Regards,
> Dhiraj
> --
> View this message in context: 
> http://www.nabble.com/Persistent-Reservation-tf2642680.html#a7376789
> Sent from the linux-scsi mailing list archive at Nabble.com.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
