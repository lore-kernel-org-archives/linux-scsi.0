From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: Adding a new FC disk to a linux host
Date: Thu, 13 Feb 2003 16:27:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6871F3A0.88EB586B-ON87256CCD.00024297-88256CCD.000268A6@us.ibm.com>
References: <JOEEIMDPCNOOJCHLMKHMCEGMCKAA.suresh@veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <JOEEIMDPCNOOJCHLMKHMCEGMCKAA.suresh@veritas.com>
List-Id: linux-scsi@vger.kernel.org
To: Suresh Kr N <suresh@veritas.com>
Cc: linux-scsi@vger.kernel.org





>         *     CAUTION: This is not for hotplugging your peripherals. As
>         *     SCSI was not designed for this you could damage your
>         *     hardware !
>
>Is this safe in a Fibre channel SAN scenario ? could it corrupt an ongoing
>data tranfer in a fibre channel SAN scenario ?

Fibre channel was definitely designed for hotplugging.  You don't have a
problem here.  The only thing you have to worry about is getting Linux to
admit that there's a device present that wasn't present before.

