From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: /proc/scsi/map
Date: Tue, 18 Jun 2002 08:40:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9E7601D4.31CCE1B5-ON87256BDC.00556B8A@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>


>There simply is *no* guarantee here of
>any consistent naming, so don't bother trying to claim there is.

That's quite an overstatement.  With a minor and reasonable qualification,
there is a guarantee.  That qualification is that you keep your controller
numbers the same.  On the myriad systems that have only one controller,
that is a very reasonable qualification indeed.

There are always qualifications when we say "guaranteed."  Here are some
others in this case that you didn't mention: you keep the device jumpers
the same, you keep the logical unit numbers the same (frequently not the
case with large storage subsystems), you keep your devices plugged into the
same place.

And that's without even getting into the higher issue of what does "the
same device" mean?



