From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI Change Log
Date: Wed, 25 Sep 2002 10:08:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925170843.GA1384@beaverton.ibm.com>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C4DAB@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <08628CA53C6CBA4ABAFB9E808A5214CB0C4DAB@mercury.infiniconsys.com>
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

Heinz, Michael [mheinz@infiniconsys.com] wrote:
> Dumb question:
> 
> The change log for SCSI devices in the 2.4 tree hasn't been updated since 1997. Is there any place I can get a list of the changes to the SCSI 2.4 tree - in particular between 2.4.7 and 2.4.18? We're trying to understand what the impact is of moving our HCA code from RedHat 7.2 to 7.3 and up.
> 
> --

Since you mention RedHat kernels someone from RedHat may need to comment
on specific patches they carry or you can check out vendor patches at:
http://www.kernelnewbies.org/kernels/

Douglas Gilbert has a change log in the SCSI-2.4-HOWTO located at:
http://www.torque.net/scsi/SCSI-2.4-HOWTO/chg24.html

You can also grab a bit keeper tree of linux-2.4 and generate a diff
change set on the core scsi files. Though you will need to do a little
script filtering I believe.

-andmike
--
Michael Anderson
andmike@us.ibm.com

