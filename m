From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: fix io drop during the reset
Date: Wed, 13 Dec 2017 21:23:54 +0000
Message-ID: <c2a7ecdf480c4946aa5571469685802c@microsemi.com>
References: <1513107610-24451-1-git-send-email-prasad.munirathnam@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0089.outbound.protection.outlook.com ([104.47.37.89]:43712
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753682AbdLMVX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 16:23:59 -0500
In-Reply-To: <1513107610-24451-1-git-send-email-prasad.munirathnam@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Prasad B Munirathnam [mailto:prasad.munirathnam@microsemi.com]
> Sent: Tuesday, December 12, 2017 11:40 AM
> To: Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>; Dave
> Carroll <david.carroll@microsemi.com>; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>;
> martin.petersen@oracle.com; james.bottomley@hansenpartnership.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] scsi: aacraid: fix io drop during the reset
>=20
> "FIB_CONTEXT_FLAG_TIMEDOUT" flag is set in aac_eh_abort to
> indicate command timeout, using the same flag in reset handler
> causes the command to timeout and the IO's were droped.
>=20
> defined a new flag "FIB_CONTEXT_FLAG_EH_RESET" to make sure IO
> is properly handled in eh_reset handler.
>=20
> Signed-off-by: Prasad B Munirathnam
> <prasad.munirathnam@microsemi.com>
> ---
Reviewed-by :Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
