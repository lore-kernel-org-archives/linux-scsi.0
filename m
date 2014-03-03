From: adam radford <aradford@gmail.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 13:01:40 -0800
Message-ID: <CAHtARFHALG5gCKRde0r3sZ=rv6stbDU14Q+1MpUxT5Z4pDS-5w@mail.gmail.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
	<20140303160944.50ba399d@harpe.intellique.com>
	<CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
	<20140303163317.543e9a98@harpe.intellique.com>
	<CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
	<20140303183531.7ffedbe6@harpe.intellique.com>
	<CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
	<20140303190535.17a21733@harpe.intellique.com>
	<CABA7EgAFi_Geq2Kf6jAOXOLvrKPbPo+4JwWwOh2FdAmK6bkr5w@mail.gmail.com>
	<CABA7EgC8gpzqMO=J6KvE6KHREJ=KEgEK2bkkPAUSgoLz295Ktw@mail.gmail.com>
	<CABA7EgBFBNdgt6Dj6qHGrPKRMC_JUO4Zqu0OdYcDzv0nh9dNiA@mail.gmail.com>
	<20140303213712.6b226d01@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:33050 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaCCVBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 16:01:41 -0500
Received: by mail-yh0-f54.google.com with SMTP id c41so4144475yho.13
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 13:01:40 -0800 (PST)
In-Reply-To: <20140303213712.6b226d01@galadriel.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Istvan/Emmanuel,

>> 08:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID
SAS 2208 IOV [Thunderbolt] [1000:002f] (rev 05)

I will be sending a driver patch for megaraid_sas to support the Dell
PowerEdge VRTX/Shared PERC8 device later this week.  This will allow
you to run Linux with the megaraid_sas in Virtual Function (VF) mode
on the VRTX blades.

-Adam
