From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Patch]: Enable SCSI Wait Scan only if BLK_DEV_INITRD is set.
Date: Tue, 23 Feb 2010 22:07:12 +0100
Message-ID: <4B844380.5000007@s5r6.in-berlin.de>
References: <4B830AEB.3010905@googlemail.com> <4B83FD7E.1070601@s5r6.in-berlin.de> <4B8424FC.5060203@googlemail.com> <4B843FFD.6080005@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45809 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0BWVHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 16:07:22 -0500
In-Reply-To: <4B843FFD.6080005@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Joe Eykholt wrote:
> Ren=E9 Bolldorf wrote:
>> On 02/23/2010 05:08 PM, Stefan Richter wrote:
>>> There needs to be an additional "depends on m" now that you made it
>>> visible, so that it cannot be set to y.
[...]
>>  config SCSI_WAIT_SCAN
>> -    tristate  # No prompt here, this is an invisible symbol.
>> +    tristate "SCSI Wait Scan"
>>      default m
>> +    depends on m
>=20
> Seems wrong to me (not a Kconfig expert).  Is there a CONFIG_m symbol=
?

"m" is a value, not a symbol.  It is explained at the end of
Documentation/kbuild/kconfig-language.txt.

> It already has 'depends on MODULES'.
>=20
>>      depends on SCSI
>> +    depends on SCSI_SCAN_ASYNC
>>      depends on MODULES

This on the other hand is a symbol which is set if loadable module
support is desired.

(Now that you mention it, "depends on m" actually implies "depends on
MODULES".  But not vice versa.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D- --=3D- =3D-=3D=3D=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
