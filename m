From: "Dimitrios P. Bouras" <dbouras@hol.gr>
Subject: Re: aix7xxx driver 5.2.4/5.2.0 vs. 6.2.5 with onboard aic7896/97 Ultra2 controller
Date: Wed, 08 May 2002 16:20:11 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CD9260B.9050601@hol.gr>
References: <200205071431.g47EVI906181@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Justin T. Gibbs wrote:

> 
> Go into the SCSI-Select BIOS option for each channel.  Set some speed
> other than the fastest speed for all devices.  Save the result.  Go
> back into SCSI-Select and select the fastest speed.


Doug Ledford wrote:
 >
 > I'd be interested to know if changing the speed and saving it, then
 > changing it back and saving it does solve the problem.

  Yup, it did the trick all right! I set the speed for all devices
  to 20 mb/s and then back to 80 mb/s. Now the speed settings when
  using driver v2.6.5 are the same as when using v5.2.4/5.2.0.

  Many thanks for the help.
  Regards,

  Dimitri


