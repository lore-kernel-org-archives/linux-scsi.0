From: Christer Weinigel <wingel@acolyte.hack.org>
Subject: Why not CAM?
Date: 27 Oct 2002 16:26:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87smyrgaxt.fsf@zoo.weinigel.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've wanted to ask this for a long time: Why not switch to SCSI CAM
when you are redoing the Linux SCSI layer anyways? 

This is not intended to start a flamewar of any kind, I don't know
very much about CAM except that it is some kind of standard and
FreeBSD uses it and they seem to be mostly happy with it.  So I'm just
curious if any of the SCSI hackers think that CAM would be worthwhile
and if not, why?  Too heavyweight?  Too ugly?  Won't fit well with the
new BIO design in the 2.5 kernel?

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Freelance consultant specializing in device driver programming for Linux 
Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
