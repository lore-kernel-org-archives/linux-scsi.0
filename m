From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] scsi sysfs (upper 2/3)
Date: Tue, 26 Nov 2002 17:58:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021126225828.GJ3664@linnie.riede.org>
References: <20021126081047.GA3280@beaverton.ibm.com> <20021126081252.GB3280@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021126081252.GB3280@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Nov 26, 2002 at 03:12:52 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 2002.11.26 03:12 Mike Anderson wrote:
>  [upper level]
>  	- Minor changes to Scsi_Device_Template init.
>  
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
>  sd.c |    5 +++--
>  sg.c |    8 +++++---
>  sr.c |    6 ++++--
>  st.c |   10 ++++++----
>  4 files changed, 18 insertions(+), 11 deletions(-)
> ------

Ahum,

If you touch st.c like that, you have to do osst.c too!

Thanks, Willem Riede (osst maintainer).
