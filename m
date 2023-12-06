Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Yv96YNKZ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="EGfzHvnh"
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06AD5B;
	Wed,  6 Dec 2023 09:08:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1701882490; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ka3UDjPl2c7leKA6Ek0Azb5CTKqmCAuMBQgi1Ex9/1N/5JNDFidava6p59HdaxlmHU
    bQH+RyjhXiWGU+L9nb05rEQtSxROhHn5mRuel7kDF79elLlplksswlrDe/qns2MZxYp2
    lv8OtPekwcoaM419Y8HF8GWlw/F6E/S4ugsF+OZDvtEj8yTp+uHrudoDGcRC7oW7N5Mg
    2iHVDsOfmQ8QQvYy339gyadvWRSqk3d30+CA9lqm+4mPX4qHZsgo50mqZEeIXxokS7UT
    zJbaa8lOVgSgPqiaFwebHJ5rSmUDYkJN6LZPGrDxofWIPQzd7if4Dnl7qzzOGDg/JZMT
    27+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1701882490;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MpCfGsUuHynGtqPq0PTKTyAWmIN/QIMrIH+zuOletHM=;
    b=fCvsVGQLYbTK5n7Rdnr4gNSVfkeTPjlzU+avZcF9h52iGsPeRjV31HFCa3WUHLRV2O
    zr4PBE5xCHCR2ueMkfJUj0I3/+FKiCs4ZyiAz6FkWSKN9nGFl8fdH1oNXBL3oDXYbXWR
    GIP3bLXvGslJCK9w1zACeh37Zh+0ZkwS0XEzy+jtbbQXS1k4hUBvUvaviWjOZky4mWVw
    JmzS4njW2uh0gpxCzezUBqC12oUPEPBF5kbSBAGosgFYzpCuaNykFI7lJRd3VgL+ybfr
    BUkBPxxVQ3ScUhtsKdU+Ab3747d/ZlhYeVf+iTZLpObScKPpA4UaeZNHuaAGTdKS0EXB
    qTDg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1701882490;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MpCfGsUuHynGtqPq0PTKTyAWmIN/QIMrIH+zuOletHM=;
    b=Yv96YNKZYpT5kf/OqXPNnhAzz8CpJgqSGrQ34Uu3zYgzNDsDiXS+ow+jTSEFqUPLkP
    KZFByeyMugWPTCBpUbOOmL1DmhTm6V/XPaND6OTkaFH+saZiEemrfy4P5FymTbKS+rGv
    Q7lk0xCsoomNbqbLZosDRKeGNs/EPlXEYXMoSCLT6oAyfet6i379XFce4ClVje3URmTE
    /QTk6L6kwvjc3CJRd55oAWEuuqaZSF53MWJ/gHqjvhnbRyJIdpvM8UTvEUkUY6LBmiCn
    Sh3SLlAm86LLqfFwfbpuBMfcHXJcjCiQwtw8MFNdr4Ho32wRT/bkcJtLomdc5kS/OgOA
    iqQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1701882490;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MpCfGsUuHynGtqPq0PTKTyAWmIN/QIMrIH+zuOletHM=;
    b=EGfzHvnhuU6Vi+rHgr0aFckImFsbSVeLMDCVrcbcN4NDC7k8/TkxeP6mg0L02Ng8/r
    wA5jjEJj06QIne6kEgCw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JCAPyj3VPAceccYJs0uz"
Received: from [10.176.235.119]
    by smtp.strato.de (RZmta 49.10.0 AUTH)
    with ESMTPSA id z4c2a6zB6H895t8
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 6 Dec 2023 18:08:09 +0100 (CET)
Message-ID: <15dd7daad07eb465f9fcd39ad44bcc40b4e19b77.camel@iokpp.de>
Subject: Re: [PATCH v3 0/3] Add UFS RTC support
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, mani@kernel.org, 
	quic_cang@quicinc.com, quic_asutoshd@quicinc.com, beanhuo@micron.com, 
	thomas@t-8ch.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 mikebi@micron.com,  lporzio@micron.com
Date: Wed, 06 Dec 2023 18:08:08 +0100
In-Reply-To: <20231202160227.766529-1-beanhuo@iokpp.de>
References: <20231202160227.766529-1-beanhuo@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Bart, Avri and all UFS developers,=20

do you have any new comments and change I should?

Kind regards,
Bean

