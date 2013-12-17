From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 6/6] libata: return power status in REQUEST SENSE command
Date: Tue, 17 Dec 2013 13:35:01 -0500
Message-ID: <52B09955.6000106@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <1387236657-4852-7-git-send-email-psusi@ubuntu.com> <52B091C6.4050106@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:56903 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab3LQSfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 13:35:02 -0500
In-Reply-To: <52B091C6.4050106@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/17/2013 1:02 PM, Sergei Shtylyov wrote:
> Isn't it an optional command, belonging to the power management 
> feature set?

Seems to be required.  ATA-8 section 4.16 says:

"A General feature set device shall implement power management"


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSsJlVAAoJEI5FoCIzSKrwieEIAKA6y3RdJO20gUyyxBQ8lRYV
jcEOcZpbBZPXNAFKXG8HvGwIIOiFNmygoSmq2q4WL2M2PUjBMkdltqcKIJgyxjW5
071HdiwAclt/KibVM2CC2PaZBVTMlCBb615B+wwjmiRveVMED9nh7htqxiKWHX16
u7T9J6Lq6nuTsoYrwGbd7c/oB5AQE6M1qDIJFtw6V7otRPYaL+P2zofhrcmBeOAe
COi/SZiQXksUHA0aSIvTpOS2zMnuHu8Uo9cpIS++gsUqsfuIkqqsyp79fbPIvqvm
WaZg43lzrFhoiZmyy/cvPm7Ty4dTkRbGo7BQ0V4S9GeSGcGRki8eZBIkHd1F4d8=
=i1f0
-----END PGP SIGNATURE-----
