From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] reduce stack in qlogicfc.c
Date: Tue, 11 Mar 2003 23:20:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030312072049.GA2428@beaverton.ibm.com>
References: <3E6ECFAD.A4363F5E@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E6ECFAD.A4363F5E@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <randy.dunlap@verizon.net>
Cc: linux-scsi@vger.kernel.org

Randy.Dunlap [randy.dunlap@verizon.net] wrote:
> Can anyone suggest way(s) to have the isp2x00_make_portdb() function
> called over and over again until it gets its job done?
> Or does anyone even still use this driver?

We have been using the Feral as it covers both Qlogic SCSI and FC cards
(both 2200 and 2300 series, the qlogicfc only handles 2200). I believe
Andrew Morton is carrying the driver in the mm series of patches.


-andmike
--
Michael Anderson
andmike@us.ibm.com

