From: Jeff Chua <jchua@fedex.com>
Subject: RE: HP LH & Adaptec aic7xxx Linux problem
Date: Tue, 29 Oct 2002 11:45:33 +0800 (SGT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210291139240.2898-100000@boston.corp.fedex.com>
References: <63645EA132F6D211AE29009027303EFF0244F038@postman>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx14.sac.fedex.com (mx14.sac.fedex.com [199.82.159.12])
	by mx13.sac.fedex.com (8.12.3/8.12.3) with ESMTP id g9T3kvAe097823
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 21:46:57 -0600 (CST)
	(envelope-from jchua@fedex.com)
Received: from inet01.prod.fedex.com (inet01.prod.fedex.com [199.81.10.25])
	by mx14.sac.fedex.com (8.12.3/8.12.3) with ESMTP id g9T3kugc016071
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 21:46:56 -0600 (CST)
	(envelope-from jchua@fedex.com)
Received: from entpm11.apac.fedex.com (entpm11.apac.fedex.com [155.161.92.11])
	by inet01.prod.fedex.com (8.12.3/8.12.3) with ESMTP id g9T3ksdh024980
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 21:46:55 -0600 (CST)
In-Reply-To: <63645EA132F6D211AE29009027303EFF0244F038@postman>
List-Id: linux-scsi@vger.kernel.org
To: David ROBERT <DROBERT@GENERIX.FR>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Mon, 28 Oct 2002, David ROBERT wrote:

> Our latest try was to install a RedHat 6.2
> And all our SCSI controlers work then properly, as well as the DAT drive.

That's interesting.

> The problem is that we do need  RedHat 7.x for our Oracle database.
>
> So here is the question we are thinking about : can we get the 6.2 drivers
> for Sym / NCR controler and/or adaptec cards to compile correctly under 7.x?
> (I know... that's unorthodox, but deseperate situations call for desesperate
> solutions)

You can try compiling the module. But I won't count highly on that.

Alan, I was having problem with HP LH with the Adaptec aic7xxx driver, and
David got aic7xxx working on RedHat 6.2 but not 7.x on the HP LH. I had
given up hope of ever getting the aic7xxx to work on the LH.


Here's the dmesg again ...

	aic7xxx: PCI Device 1:2:0 failed memory mapped test
	ahc_pci:1:2:0: No SCB space found


David, could you please send the "dmesg" for the working system...

Thanks,
Jeff.

>
> 	David ROBERT (DROBERT / ROD)
> 	Responsable Informatique Interne
> 	drobert@generix.fr
> 	+33 (0)3 20 41 48 35
>

