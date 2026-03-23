Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6492DB7BB;
	Mon, 23 Mar 2026 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257472; cv=pass; b=S+sSyv8Ypudi44zZ+xsPLiDX3xwjal8Mj/GYtx4Qvu4iwF0YUnSIERzKuS55JCpFA46wLyI2QX75SxSBGNneuVcXu3UOnDt6Tk1EEvyfwcfLrpzWcbjnZlg84LrhRH+eH12iMl062cABYpmpRXYaK3LD8UsnpZU8wK0LFlTg79s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257472; c=relaxed/simple;
	bh=XCO05ahb3GChOwlGwfi+KKl2FsBfXtNjxsM6x9JS818=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nFZOWos2m3AsmSWX7gA2TNDDLl03mnp0KsvcIp5lnCuxES+D2bp6ndjVUJjV5H4EyyX4Q8akYcR0/qgoNnynWkvw2dV7XzE4qc9VXXDUOK4p3XhLT6xDTQfuh0m+Q6qbtp482jZazlOrAXmIHbivzrJ1WpZ9pZfnl3wZmGip3y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UFyWrnvX; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=S/S3uWVp; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UFyWrnvX";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="S/S3uWVp"
ARC-Seal: i=1; a=rsa-sha256; t=1774257450; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=m6LA43iQganYeB0j6xc3DyYgxgNZPMm/fjYtm5lv6pQSxzJyQPkZgUOaWEx7Nqasu0
    x/YjINZHFWNpKZHJG06I8bOwSVHHtfFq4Q1Wmet7Cp59trnPn194a1EVjT549EdUmuIE
    Y9fmlJKyYXvYyoPpJ7JvChgRxZD1AUz3ZAl3s0W/4OaDi6+GU9XAsIcdb7vzD2QownJ+
    zD0iyCeB+jDctgk7m4uB8ne/96U8QC0WoM5OPx6kE1MTA0MX9mADH24Mz5kuDFe8SMCb
    p22uItVRooQGE6Dy7NB9kGR1GT9QJAuSr20eXKX3lrpvGpVn5dne7C+FuMSk+RaJC4xT
    6QZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257450;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XCO05ahb3GChOwlGwfi+KKl2FsBfXtNjxsM6x9JS818=;
    b=Hy0lDHZM73X9kDR9yExA2kgABRDQiCswIyCHJ2ITSA1GKZAvJEMs1BiCXCwV+ZQj6m
    J7qoFvrkeFw6Db/WUzshI2o5ZsV4/QtUOUjMHbwUI4MAUjd7FAGxX2g0iQfRQo+Obbm2
    rr8X9h5NuAt8GiUs2SRukcd0nrOPezyA6eLQAnnkGtgOpNlwLktB7B81duQ1qBE4+03U
    +NcjCETSP8Ay4i48G7Web+eUx5+gQbTNxV2PZxnOcOZWkL3WqD6J/HFk1KO0lLV8SCti
    C8ugtL5lax4M3Vp+VWh8CKPdhQEBvi+Rdi7eJuoDx+0PSdnWQuNsM/Ai+TudkA9wONIT
    xlyw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257450;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XCO05ahb3GChOwlGwfi+KKl2FsBfXtNjxsM6x9JS818=;
    b=UFyWrnvX5wNhpy9qXrd0KPTVIWlFkVGLlxel+aNdPBQQ9yOJAAPGeVcFWBfRCOsjTG
    L+E2zf/odOTBxkOtWWbZ+g63OwiVW+8GV1NxKAiaSoUwL/M2IXIfOBLAKnsCAePqdCFQ
    jbdfUlPUGkYymO/qOMSSlenjGGpUFYlykODJtbSIu6BxhNTYuPwWL7CG5Y0NkfYAeGrD
    aliqP/rr/i1h76P5B/ybA7sLjtnrcOgvsG0o+tzu8ANnxElqfuz8YXgrr2TnDGYFkQP5
    5CrxXzNzrRZ9vMaCY4VLlaosL/wuoBrcY6xoicrD9QElEmCHQqHIXBaEDILtnXCwGS03
    fMEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774257450;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XCO05ahb3GChOwlGwfi+KKl2FsBfXtNjxsM6x9JS818=;
    b=S/S3uWVp8OngkTZzYp9NuDM0YMLyaGa2BmADaJ4J85eqZjkbDB8+3nl0Kixt5ea6pB
    TQF6caEAwCu57yjLm6Bw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522N9HUQM8
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 23 Mar 2026 10:17:30 +0100 (CET)
Message-ID: <05cd67cd012a4c7f7f4e476a2418f192a4c7fc9c.camel@iokpp.de>
Subject: Re: [PATCH v4 06/12] scsi: ufs: core: Add helpers to pause and
 resume command processing
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter
 <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:17:27 +0100
In-Reply-To: <20260321031021.1722459-7-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-7-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> In preparation for supporting TX Equalization refreshing, introduce
> helper functions to safely pause and resume command processing.
>=20
> ufshcd_pause_command_processing() ensures the host is in a quiescent
> state by stopping the block layer tagset, acquiring the necessary
> locks (scan_mutex and clk_scaling_lock), and waiting for any
> in-flight commands to complete within a specified timeout.
>=20
> ufshcd_resume_command_processing() restores the host to its previous
> operational state by reversing these steps in the correct order.
>=20
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
