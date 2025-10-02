Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADCD28FD;
	Thu,  2 Oct 2025 04:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759380586; cv=pass; b=fxS0RgjKKH3XKf2iDVY2ettqFn0M9KgRZBcoRQFXiXE8xjnRQFjXchZdFkcSyiUJOnQdPa9rbPzpj9BJq+3GC4p4jrNSPzR0G3tCiZCHWg+C20ekRyCt4mOrWsjpcj09TySkO+GlkIekQJSyUe672WDSfcnk5VYn6lBkEKObAh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759380586; c=relaxed/simple;
	bh=C4jK5CO5PsfOIxmxUrT3fIAH4o6U/8d3o32rKxowRzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IMShsHEYe0elCfvm0DwU44ZMxH84cUL+dMxasN6ok0uTzHpxXnymXr7/BExcgDGNS/+Cwl0/JBU3G9/CL+H9cmPd+Ehsc0EKldBQkGpSjKAkkOuoR/KL0M/5D62Hq0wiiSWNgC6rhdNhuLCVWekvFFS7XURlIxlD4r5hLDh3NrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=JEwqu6u+; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="JEwqu6u+"
ARC-Seal: i=1; a=rsa-sha256; t=1759379502; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LcWFjsV0kSImhtYAUd+NXpZE5qfwfEgcx6rcHbdMPHPlDmBhVElrFlTGppcpz36n0a
    BIHnKkRzvoGR5vrqJsrPBw1dBEzljEIARFdFBuR1x13Nve81KHkzH8hQt0OpY06y7Pvu
    ESmeFTlwM19+qTh0jEoj0o2YV+cNAvCUY2ynxNjgJztJuYBpu2ERoVCJBHMjymRZvkdQ
    DbBpXceLohKFvc0YY/O9B/VcJlKwWU8tqFycbbvNKbAPqtwJMwuZ7lwkVsKrgQVN7nVZ
    jjf5EDcVaz89hGYa58+woCcN46Oe0RXc4jGhHpFBaAZUkRm1utYCYuQM7fd6EIuqOXn9
    ByyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759379502;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=C4jK5CO5PsfOIxmxUrT3fIAH4o6U/8d3o32rKxowRzw=;
    b=gLz+pdj+8jvc6nbs2yvkgguaclD8y5X5hZMfqsIrWzdzg4lNy9dVGhUmMCc2YiO8g0
    Smq4m6RA8H62ZXr0Y2AQqqUPcdgHUnlgDblajaXHL3SyN0JCFtPIdTWW1EintEWjF3d1
    du7uuhEWPROecAgPXwW2af3k6yTmgAoeGt3Xs1IoTU6FJyfojj5QGFcTWVPLPuTPeGLr
    p3cSyn3oYNqEUEYAkdgyS4V45X6j19Fu3SwvU2WxZrNbkbt/Vikb0odg/pJTgNu8aQCF
    x0PfMys8FkZSnyoFr8da/OYfGEwrZ66gmweGW0BbbpLXav4DqNlCQGqbFNNBEJWlmfEu
    Qw+g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759379502;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=C4jK5CO5PsfOIxmxUrT3fIAH4o6U/8d3o32rKxowRzw=;
    b=JEwqu6u+BE09OxiQAZDCwKxQBfo2FYowJ5jARQ3IDh4maWX7dAUeeG+UuSWbcFpdEO
    O/srcuNoRQWSaG0DSXX+YF6MmfQ3aj2iANPMXTE0fcm9JLkVKmicstPVu9d3H+qjsgRC
    xBskPjFQTg7aV9qZVQUKFTYWAwceKlMBuPXbghVKD/FePI/mZiq1bfn5IxhoA6dAUyF8
    9Pmn/MuzjwaU4iCGAghcEp1zrvQgxR2fetYXoc3e/XFRkItX/R09uoCGJ2LzV3qnl5r1
    oCNhsLD0En4aSTWu8Ili5hQs1cMDh35S1PEOowTJQ84YNw7cYcy51EVOOYmOTpOwtpyl
    XcWA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DRtlXRrepcRHsGkBA=="
Received: from Munilab01-lab.fritz.box
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc61924VecSO
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 2 Oct 2025 06:31:40 +0200 (CEST)
Message-ID: <bcd555740e1168fb9237683b136cdfdac9a6916a.camel@iokpp.de>
Subject: Re: [PATCH v2 2/3] scsi: ufs: core: fix incorrect buffer
 duplication in ufshcd_read_string_desc()
From: Bean Huo <beanhuo@iokpp.de>
To: Avri Altman <Avri.Altman@sandisk.com>, "avri.altman@wdc.com"
 <avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>, 
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
 <jejb@linux.ibm.com>,  "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
 <can.guo@oss.qualcomm.com>, "ulf.hansson@linaro.org"
 <ulf.hansson@linaro.org>,  "beanhuo@micron.com" <beanhuo@micron.com>,
 "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Thu, 02 Oct 2025 06:31:39 +0200
In-Reply-To: <PH7PR16MB6196EB54F847DD32DE097770E5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-3-beanhuo@iokpp.de>
	 <PH7PR16MB6196EB54F847DD32DE097770E5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-01 at 10:03 +0000, Avri Altman wrote:
> > From: Bean Huo <beanhuo@micron.com>
> >=20
> > The function ufshcd_read_string_desc() was duplicating memory starting =
from
> > the beginning of struct uc_string_id, which included the length and typ=
e
> > fields. As a result, the allocated buffer contained unwanted metadata i=
n
> > addition to the string itself.
> >=20
> > The correct behavior is to duplicate only the Unicode character array i=
n the
> > structure. Update the code so that only the actual string content is co=
pied
> > into
> > the new buffer.
> 2 Nits - only If you'll have another spin:
> Nit 1: maybe add one more sentence: This does not imply any ABI change as
> there are no current callers with SD_RAW
> Nit 2: you might want to remove the duplicate definitions of SD_ASCII_STD=
 &
> SD_RAW

yes, thanks Avri. I will address it in next version.

Kind regards,
Bean

>=20
> >=20
> > Fixes: 5f57704dbcfe ("scsi: ufs: Use kmemdup in ufshcd_read_string_desc=
()")
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>


