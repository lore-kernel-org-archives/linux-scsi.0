From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] copy_XX_user for sg.c - take 2
Date: Thu, 18 Jul 2002 11:59:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020718021010.1ED4C4421@lists.samba.org>
References: <3D34E3BA.2B2EE2AC@torque.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 16 Jul 2002 23:25:46 -0400."
             <3D34E3BA.2B2EE2AC@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, wstinson@infonie.fr

In message <3D34E3BA.2B2EE2AC@torque.net> you write:
> >   here is version 2 of my sg.c patch to correct indentation to 4blanks as y
ou pointed out (I hope I didn't miss anything).
> 
> Rusty,
> This patch, together with one to disable kiobufs usage
> (for Andrew Morton's direct-to-BIO changes), are in
> lk 2.5.26
> 
> Doug Gilbert

Hi Doug,

	I have automated scripts which closes the trivial patch and
mail out when this happens (I get about 20 patches a week through the
trivial patch system at the moment, so I need that).  Indeed, it sent
out the following when 2.5.26 was released:

================
From: Trivial Patch Monkey <trivial@rustcorp.com.au>
Subject: Re: [PATCH] copy_XX_user for sg.c - take 2: Patch is closed.
To:  william stinson <wstinson@infonie.fr>

Patch is closed.

Status of this patch:
  2.5: 2.5.26: Some parts already applied?

FYI: You can put "No Status Update" somewhere in your mail body before
the patch to disable status tracking (you will still get an initial ack).

Complaints etc. to trivial-feedback@rustcorp.com.au.
================

But thanks for the confirmation!
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
