Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BDC3E638D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441783; cv=none; b=Q+LGt3mmtO/Cv+4U36nZHD4OLC3d756Qzoxz/nT6BBQs4EMo+twSIJlma2UdneSePCr8kfpXkaWrGzVizxvpY1G6dW0hxePzcDdEW7aIMm8zF3seZfC8ZLE3Qnq9+pPJ/sQrf3nTKVuBW5WAbt4UeCTudWBNPmb3V/Nu0yhtNpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441783; c=relaxed/simple;
	bh=qWWYStfxREnOME4IaVwth8YwJryW+tD+KhqzhqrhJ00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwGpATA1OEJiBFOC4gFPh43kd/O7zuOhprION4AJfughyDGFo/jjYLQRI6BcOOeLe8z/jlocy7oJZMBlNoWeQdcVPRnSK1WWoWbxmfPd9IYYTKiKu7hmoMcXWyA1UZGNup9Om95MW/iUaHSbDKyaA3F4bj1dT0BViqdmzwLTtLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=et3aLblR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="et3aLblR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B431F00A3A;
	Tue,  7 Jul 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783441780;
	bh=MoyCaEVdrCJa3r5cA3QWeVLYQoSRJLdJgCONMXIOxv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=et3aLblR3KRd2vFAWmJhd/i0JqhMhk/Hke+Gb5DVZqi9pWXc58jvx0Lipkvt2Fmwt
	 rpwgXHtYnrpYZuv1k6k1ryKZ5GTH1JpR5/Zi9xFb8YvU59JdOObcEv86F2TcTC0kvm
	 xsYwx8b0EQUzR8n0+34DbMO3FpeKZAj2Y5/hZEvVZBazHwfu+8BvnI5QT3/c7FtAqF
	 RH7OsXl6wj5YszI5QXt1poGJrx4HuYJJKkRbsuiER3iO5YbZLdAnZf6bkl4qfETs3C
	 N9ErP9CI4oE9eDSO6hTrJNJWD89p/ZYBtaur9ZZAKjnYAKS+bRF31fdV9pZd+g8gHZ
	 02W/x3oUDxKDg==
Date: Tue, 7 Jul 2026 18:29:33 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Avri Altman <avri.altman@sandisk.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: Undeliverable: Re: [PATCH v2] scsi: ufs: core: Avoid possible
 memory reclaim deadlock in TX EQTR context
Message-ID: <ucn5winjeqnixycuxldp3wgysrasrah4ie5egs4vo4prvy7e5c@6ef4y2gqqd7x>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
 <h5lsilzmxhu3jyujladib3w75nsute7yrkr4t5sg57nwzwb2ek@d4btnbylvrvu>
 <f1960bd5-b583-4104-a343-e217ef7ed63d@SJ0PR04MB7504.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1960bd5-b583-4104-a343-e217ef7ed63d@SJ0PR04MB7504.namprd04.prod.outlook.com>

On Tue, Jul 07, 2026 at 03:58:12PM +0000, postmaster@sharedspace.onmicrosoft.com wrote:
> Delivery has failed to these recipients or groups:
> 
> Avri Altman (avri.altman@wdc.com)<mailto:avri.altman@wdc.com>
> Your message wasn't delivered. Despite repeated attempts to deliver your message, a connection to the remote server couldn't be made.
> 

Hi Avri,

Are you willing to continue your role as UFS reviewer? If so, could you please
fix your email address to avoid bouncing?

I can also send a patch for that if you want. Let me know!

- Mani

> Contact the recipient by some other means (by phone, for example) and ask them to tell their email admin that it appears that your email system is unable to connecto their email system. Give them the error details shown below. It's likely that the recipient's email admin is the only one who can fix this problem.
> 
> For more information and tips to fix this issue see this article: https://go.microsoft.com/fwlink/?LinkId=389361.
> 
> 
> 
> 
> 
> 
> 
> 
> 
> Diagnostic information for administrators:
> 
> Generating server: SJ0PR04MB7504.namprd04.prod.outlook.com
> Receiving server: SJ0PR04MB7504.namprd04.prod.outlook.com
> 
> avri.altman@wdc.com
> 7/7/2026 3:58:12 PM - Server at SJ0PR04MB7504.namprd04.prod.outlook.com returned '550 5.4.317 Message expired, cannot connect to remote server(Failed to connect. Winsock error code: 995, Win32 error code: 995)'
> 7/7/2026 3:48:53 PM - Server at 199.255.45.85 (199.255.45.85) returned '450 4.4.317 Cannot establish session with remote server [Message=Failed to connect. Winsock error code: 995, Win32 error code: 995] [LastAttemptedServerName=199.255.45.85] [LastAttemptedIP=199.255.45.85:25] [SmtpSecurity=-2;-2] [BL02EPF00046C14.namprd07.prod.outlook.com 2026-07-07T15:48:53.514Z 08DED27250BC5691](Failed to connect. Winsock error code: 995, Win32 error code: 995)'
> 
> Original message headers:
> 
> Received: from SA0PR04MB7354.namprd04.prod.outlook.com (2603:10b6:806:e9::12)
>  by SJ0PR04MB7504.namprd04.prod.outlook.com (2603:10b6:a03:32e::6) with
>  Microsoft SMTP Server (version=TLS1_2,
>  cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Tue, 7 Jul
>  2026 13:57:00 +0000
> Received: from SN7PR04MB8601.namprd04.prod.outlook.com (2603:10b6:806:2e2::13)
>  by SA0PR04MB7354.namprd04.prod.outlook.com (2603:10b6:806:e9::12) with
>  Microsoft SMTP Server (version=TLS1_2,
>  cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Tue, 7 Jul
>  2026 02:47:13 +0000
> ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
>  b=ZQZLmSN8ZFt3IqVJ+cvs0l6ccWzVpwOSpEyJmJ+buB9AuhTJPwhbh0sBEDya41YZzxREswQQdQgZArz7rlhFrshmUn0VawsFsux+pBziwly3isW6T1F2Hhk8JBXr7ukaSS+1J61bntprN3YvlN1DrlzF9cHOAhsMCmWYUB9EnXxzsUwkVj+ccysAKqnEps0pQtkuDqztDeHDgrXuVeykNEdM9JC+rwS9ghtX3onirrCGv+RR38kFe73WXnr9AZbH8wok6dwjqGskI1Qw9OYE5cAj5P1vqfftx72K8Ng24LG9j09bVkNQXNetb6nYT/JbtzIATbpvjEQHQPIf8l2p2g==
> ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
>  s=arcselector10001;
>  h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
>  bh=B+QafvzKcmkbe/vB2mZ7imHvd1YjyqLfJAKS3svHs6g=;
>  b=J/ILygxivJqsAxfYKfiUxNvCyshbIBp4Q2AqjodvxDC7KtKpXBnGIxUSfV9HPxpNdBIRy8eVP4QGvCLHF1fsFhqg0xEN3LzRCbI5ikGA/Or3F/NhB7calx0W1Urnsbth9wz5NrxRW3Vn9rJcJxjxh0/355YgZzYiEWfIjBfAKQXPKfTnC0XkIMR2Ty5zU36tzGKdy6qpQO9ESLlEdRD9R/LYaO+h3Ed7inKJQGy7mlyIqa3QoVLJNPUxsW4Tbg3IEnBUjhfnQ+vBsHGhOGLD6pm1Nt+3ptcMJyEXX/jb6jkjD2X5uUlP8JiLjRP8a3AsU83aVkwVTsx36BfSyyTPjQ==
> ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
>  is 216.71.154.45) smtp.rcpttodomain=wdc.com smtp.mailfrom=kernel.org;
>  dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
>  header.from=kernel.org; dkim=pass (signature was verified)
>  header.d=kernel.org; arc=none (0)
> Received: from SJ0PR13CA0082.namprd13.prod.outlook.com (2603:10b6:a03:2c4::27)
>  by SN7PR04MB8601.namprd04.prod.outlook.com (2603:10b6:806:2e2::13) with
>  Microsoft SMTP Server (version=TLS1_2,
>  cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Mon, 6 Jul 2026
>  15:45:00 +0000
> Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
>  (2603:10b6:a03:2c4:cafe::63) by SJ0PR13CA0082.outlook.office365.com
>  (2603:10b6:a03:2c4::27) with Microsoft SMTP Server (version=TLS1_3,
>  cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend Transport; Mon, 6
>  Jul 2026 15:44:59 +0000
> Authentication-Results: spf=softfail (sender IP is 216.71.154.45)
>  smtp.mailfrom=kernel.org; dkim=pass (signature was verified)
>  header.d=kernel.org;dmarc=pass action=none header.from=kernel.org;
> Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
>  kernel.org discourages use of 216.71.154.45 as permitted sender)
> Received: from esa6.hgst.iphmx.com (216.71.154.45) by
>  SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
>  SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
>  15.21.181.6 via Frontend Transport; Mon, 6 Jul 2026 15:44:59 +0000
> X-CSE-ConnectionGUID: EZy8/M+xTm6Ity5uQCDGgQ==
> X-CSE-MsgGUID: pKZerHYiT5iV8FUzkc0c7g==
> Received-SPF: Pass (esa6.hgst.iphmx.com: domain of
>   mani@kernel.org designates 172.234.252.31 as permitted
>   sender) identity=mailfrom; client-ip=172.234.252.31;
>   receiver=esa6.hgst.iphmx.com;
>   envelope-from="mani@kernel.org"; x-sender="mani@kernel.org";
>   x-conformance=spf_only; x-record-type="v=spf1";
>   x-record-text="v=spf1 ip4:52.25.139.140 ip4:172.105.4.254
>   ip4:172.234.252.31 ip4:172.234.120.38 ip4:172.105.64.184
>   ~all"
> Received-SPF: None (esa6.hgst.iphmx.com: no sender authenticity
>   information available from domain of
>   postmaster@sea.source.kernel.org) identity=helo;
>   client-ip=172.234.252.31; receiver=esa6.hgst.iphmx.com;
>   envelope-from="mani@kernel.org";
>   x-sender="postmaster@sea.source.kernel.org";
>   x-conformance=spf_only
> Authentication-Results-Original: esa6.hgst.iphmx.com; spf=Pass
>  smtp.mailfrom=mani@kernel.org; spf=None
>  smtp.helo=postmaster@sea.source.kernel.org; dkim=pass (signature verified)
>  header.i=@kernel.org; dmarc=pass (p=quarantine dis=none) d=kernel.org
> IronPort-SDR: 6a4bcd7a_OohJWw8r2oYesZY7iGnE/PXfIcBz+W9XHTzhDG1Fho2Yn94
>  tDmvoja1ScQGKub7dfIIYhyi6NgweZnBuXTTupA==
> X-ThreatScanner-Verdict: Negative
> X-IPAS-Result: =?us-ascii?q?A0FEAgCwzEtqhR/86qxTB4JZgkGBCl8zBAtJhFiIe4ZYW?=
>  =?us-ascii?q?wEBBoE+A4t0hneLMIF8AhMBDVEEAQEDBIFLgzQCjU4CHgcBNAkOAQIBAgEDA?=
>  =?us-ascii?q?gMBAQEBAQEBAQEBAQsBAQEEAQEBAgEBAgQDAQEBAQIQAQEBAUBJhk8NgluBL?=
>  =?us-ascii?q?IEmAQEBAQEBAQEBAQEBHQINfgEBAQMSEQQLAQ0BATcBDwkCGAICJgICVgYTC?=
>  =?us-ascii?q?BqCYAGCIgdKA54+jkQBgSk/AigBQAEMgQuKDn8zgQGCDAEBBgQDAgLcJIFpA?=
>  =?us-ascii?q?wYUAYEKLohbAYV2hAJ6Jxt9gRCEQD6EJQmDcIJqgiZ6EoJIjldSeBwDWSwBS?=
>  =?us-ascii?q?wo1DDMrRUMDgSkPPAU3ZRI/IR0fDh45AjgHBRIgERlBRSMDJ1k/OE4FgVkCZ?=
>  =?us-ascii?q?4EhTiMfAzl/gTB1Sjs+LYECAQIuCmxCJIEpA3g9NxQbjjIXD4IJIhEBWDYsg?=
>  =?us-ascii?q?gYFCSmTALN0hCehckkDlz2TGZkIqUKBaDqBXH0IgyJQAxkPjjoliFfJKUI1A?=
>  =?us-ascii?q?jsCBwIHDgMLkWgrCWtgAQE?=
> IronPort-PHdr: A9a23:FxhfTxQF5ttbRiTEL72JY3DJltpsosyXAWYlg6HPa5pwe6iut67vI
>  FbYra00ygOSA8ODsrkb06KW6/mmBTdcp87Z8TgrS99laVwssY0uhQsuAcqIWwXQDcXBSGgXO
>  voHf3Jeu0+BDE5OBczlbEfTqHDhpRQbGxH4KBYnbr+tQt2agMu4zf299IPOaAtUmjW9falyL
>  BKrpgnNq8Uam4RvJ6gwxxfTvndEZutayGF0KVmOmxrw+tq88IRs/iletP8t7dJMXbn/c68lU
>  bFWETMqPnw668HsqRTNVxaE6GEGUmURnBpIAgzF4w//U5zsrCb0tfdz1TeDM8HuQr46QTut4
>  751RRHnlSkLLzE2/n3Zhcx2l6JbvQmupwdjzI7OYYGaL+Rxc6XAdt4HX2VBX8JRVytcAoOga
>  oYEEuQMMfpEo4T7ulADqwa1CwuxC+P10jJGiH/407Mk3uo8Eg/G0gMvEM4Tv3rbrtr4L7sSX
>  OOuwqXU0TnPc/Fb1DHg44bIaBAhpvSMUKp3f8XLz0kvFh3FgU+WqYzjJTyV0PkGvXWB4OV9V
>  eKgkXUnqwBvoje1w8cnl47EhocPxVDC9CV024U1KsOiSE59f9GkFIFctyaAN4t5W84vRXxjt
>  ykmxLMco5G7YDQKx4o9xx7Zc/GJfZSE7wzsWeuVPDt1h29odayiixus8kWty/DxW8i23VtIs
>  yZIndnCu3QN2RHO68WKTudx8Emu1zuSyw3d5P9JLEYpnqTVLJ4hx6Q/lpsVsUnbBS/5gl72j
>  K+XdkUn/eik8fnobav4ppKaKoR6iRn+P7wzlsG9H+g0KBYCUmaU9OimyrHu/VP1TK9Eg/Eri
>  qXVrYzWKdgBqqKkHwNY3Jwv5hm/Aju8zdgVnn8KJ09fdh2dlYjmIVTOLej4Dfihh1Ssly9mx
>  +vYMbL7GJnNNX/DkKr7fblh9UFQ0gkzws5F55JSFL4BJOj/WkjrtNzXFhM5Mgq0zPj7CNhly
>  48TW3yDDrWHPK7cvlKE/PwjLumSaIMPtjvxNuAp5/v0gn84nV8dc7Op3ZwSaH2gG/RpOUOZY
>  Xv3j9cCD2gKpAw+Q/LuiFGYVj5TfXmyU7om5j4nEIKmEZvDRoe1jbObwie7BJxWanpcBVCID
>  Xfocp+LW/EXZSOcP8BujiYIWqSmS48kzR2ushT1xKJ9LuXI4i0YqY7j1N9t6uHOjR0y+iJ7D
>  8Oe3W+XV2x7kH4GSycs3K9hv0xzyU2N3LBjg/NGD9Nf/ehJUgAnNZ7G0+N1Fcr+WgHfcdeTT
>  lapXNGmDSs2TtIrzN8Ce1tyG9ajjhDGxyekGaMYmaGWCpAs763c2mL+J9xhxHvezqcsk0QoT
>  NZXOW29nq5/+RDeCZTVnkuEiqimbb8c3DbD9GibzWqBokVYUAloXKvdRH4RfkTY/pzF4RbpR
>  rnmJqkgel9KwMjEJbZNQtrylhNfWf7nM9PbZiS6nGLmVjiSwbbZSYPsensU2iPUDgA/mgwT9
>  G2HKwE7TnOkqmTfJD9jD1TiZwXr6+Yo+yDzdVM90wzfNx4p7LGy4BNA3ZR0NtsNi+tX8C50s
>  S59WU291oiLVYnIrF97caFVcd4xp01K0WvJugAudpD1LK14gFMaNQNtsBCLtXRsX4YayZJ09
>  C5zkVk6NffBjwMaLG7Cg8Gvadi1S2PyqTrsUqfYxEP929OV8KpI9t5irme8vQSJCEZ7wnd2y
>  v1b8VK/3c7REioJD52kASNVlhgvi7jGb3sT/YTRh0FrY4K/4ATf0dAkD/d38Buucs1SNqiJD
>  13TFYggCtCqOakWnAvMDHMOacB/0ok0GOGfTOuv96GJbMdbox2rtUsWvYVT0WCw+SBuFrTD2
>  ckk3c2SmQ66eSfCslm/s4PoqKRWNRsSATqTlGvEYewwLrR4ftkIFl+sLea578xgrZG3AyIH1
>  kXyDA802PK1JUuKMlftnhIX/FsQm3KmvC+V9zdSqxcVjpa6xRH80uv9VkFcIgspJSFv3Vq2D
>  afsjO9FDU/1dRQlzRu/wVrn46V4qKpvAWCMGUtDPCmrBGV8aruo54aMcu99uLIR7xhWef21O
>  gjHYJ/9jR1/sUKrRHQHxQBqK2+rn7fLzwNf003aa2xv8yDIVp1iyCfW6cbXdfwI5WsHFDtIo
>  jPlCHSOZNX0ot7FqND+4vuQVFuYU5N9FEuKhb+uuxaSyGlxOhGZusuco+T4SCYeiRP4zOFtc
>  i/N/Q/uJbLE3a7hDNl5OW9FCA7A79FmF6NXlogPm68d/Cghupq5xh9l8C+wEOhQ36SiRj0tQ
>  SAilouGqBig2VdkKGqO3Z68THiG3899MsGzeXhFsspOx5gOJKKd9rd+kCByuFbq5RqEeOV0h
>  D4b1foo5TpSm+oV7VN1lmHVGahHWQFRMS/tkkGSq5i3t71ZMXzrOaKt3R9N3Z+tCbiYqSlfV
>  Wz/d5NkGjV/oYE3aQqQgCCstNmlTZ3WatQe3vX1uxrbhrYTKJ0qirwLnSpiKST2unh2g/Ujg
>  0lW1Iqh9JOCN30r+au4BhBCMTigYsoV+xnugLxYk8LQ2JqgTd16AjteepzuQLqzFS4K8/TqM
>  wHbCDontnKSAqbSByeE5U4gtHXSCZumcXKaPn8UyZNlXhbObEBcgQVBRDwhhdZ5DQGlwsX9b
>  V10ri4c/F/2qxZAi6poOhDzX32ZpVKAaTouTpWbah1M4VIK60LcK8fL9utoBGkY5si4sQWXI
>  2qHZgJFRW0IQRmCAFbuf/GisNrN6e6VAqy5NfSmjaymkeVFTL/IyImmjM1m8C2QcMSXPnxyS
>  fY83xgLUXd8EsXf0zIBLk5f3yfEac+zpxqm/CBz6Mel/7znVRnu6o2GF7ZJeYwwoVbs2vvFb
>  bPKwn0gYT9DnosB33rJ1KQS0Dtww2l1ej+hHK5B/S/BQaTMm7NGWhsSaid9LsxNvOo32ghAP
>  9Kei8ugj+EiyKRuVxEfCAanwZj6AK5Ca3uwP17GGkuRYbmdLGONw87sfeW9Ub1VnKNfsBjj3
>  FTTW0LlIDmHkCHkEh61NuQZxiSSOh12u4yndBtpT2/5Q5i1Ig3+K9JxgTAslPcxj3XLHW0RK
>  z5xdwVKtLLavkY6yr1vXmdG6HRiN+yNnS2UuvLAJKERt/96UWxk0vhX63Mgx/5J/TlJEbZrz
>  TDKoIck8DTE2qGfjyBqWx1UpnNXiZKX6A98bL7B+MAIWG6Yrk9Xqz/NTU1R9p08VoWnurgMm
>  IGQzuSqcGoEr5SOoJd5ZYCcKdrbYiN+a1yzQ2KSVlZfC2XyfWDH2x4Ez6vUrCbJ6MFg8t63y
>  NIPUuMJDQNvUKpCVwI7QJpbcMsSPHtsh7efiIRgCWOWih7XSY0as4vOCLSSDu7zbjeBjbxUI
>  RAPxOGwK4NbLYD910F4IlBngITHHVbRVtFRs0gDJkc1pktK6n13Umw03QrsdAqs5HYZEfP8k
>  AQxj0NyZuEk9TGk5FlSRBKCvCwrjEw4gsnomxiKfTe3N6CtR4pbTSn5rU48NtX8WQk0JQy+k
>  Ep4NSvVErJci7wzEAIjwATYuJZJBbtdVfgdP0VWn6rLIa91ixIH83bv30JM6OrbBIE3mRAjL
>  9isoGlcnQN7bNslY6fXIfksrBAYi6SQsyuvzu10zhUZIhNH9WqUeQYLtVYOO71gIDCntL8Ji
>  0TKi35YdW4AWuB/6Opt7V84Mv+cwjjIyLNKbFu2KvaUIuWatnLGmMrORUk/nBBt9QEN7f191
>  sEtdFCRXkYkwe6KDxo+MszGOGm9juJJ+XGVZiGTq+7Ah5F4JYOwEqbvV+Dc7M78bWqnERwvE
>  oBK6d4OTMDE7Q==
> IronPort-Data: A9a23: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
>  T3SFrAc8PR8LlGFiNv/PsCGvNo=
> IronPort-HdrOrdr: A9a23:XH91OK/avHF0WjQD4YNuk+DdI+orL9Y04lQ7vn2ZhyY1TiW9rb
>  HIoB19726TtN9xYgBFpTnkAsS9qBznmaKdjbN/AV7mZniehILKFvAG0WKB+UyCJ8SWzIc0vs
>  1dmupFeb/N5DNB7foSjjPXL+od
> X-Talos-CUID: =?us-ascii?q?9a23=3AdLJtsGuZAXq3ZxuG0nUS/jCt6IsIQGyNi1KTM3O?=
>  =?us-ascii?q?9V0d1WeCIcHS816xdxp8=3D?=
> X-Talos-MUID: =?us-ascii?q?9a23=3Ao9c3+A2K3bbddxOV2lrmLo9bazUj+4ecBVotoJQ?=
>  =?us-ascii?q?65si6ZQJNKTSW1D/oTdpy?=
> X-IronPort-Anti-Spam-Filtered: true
> X-IronPort-AV: E=Sophos;i="6.25,149,1779120000";
>    d="scan'208";a="148946905"
> X-Amp-Result: SKIPPED(no attachment in message)
> X-Amp-File-Uploaded: False
> Received: from sea.source.kernel.org ([172.234.252.31])
>   by esa6.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 23:44:57 +0800
> Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
>         by sea.source.kernel.org (Postfix) with ESMTP id C7CD1432F2;
>         Mon,  6 Jul 2026 15:44:57 +0000 (UTC)
> Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2760F1F00A3D;
>         Mon,  6 Jul 2026 15:44:53 +0000 (UTC)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
>         s=k20260515; t=1783352697;
>         bh=B+QafvzKcmkbe/vB2mZ7imHvd1YjyqLfJAKS3svHs6g=;
>         h=Date:From:To:Cc:Subject:References:In-Reply-To;
>         b=HENOhOJQSxAGgJ8ISWGePG95mFkJTfbz42cn7IvTb/mUFxVVfvi+wYLz8Bhw8D5+H
>          qbk7kwPjfCfAqvBg2047Js9c4ZhUt49p5cx+w/AwoRfiMlEPcNPNTHTMqUZygwJ33p
>          e8e2DG0kW79o5rtd1hrLtuLeKdfxFa70dc+i5ClvPxp9TfyIZ8IQ6UiAqa305BIhFn
>          3w1iX946iMJZ8wM3G//rt72yG4zeXaercXj1S9i8zXCbZfDZ3d57c9W/U8sFkQQmfF
>          TFgUAElsSdNMSGQQw1FL0TksPoObm9qz/SGbb3USv/NEd9TlsteJAlkWwVeM8STgDS
>          +IUcnn4B/HlvA==
> Date: Mon, 6 Jul 2026 17:44:49 +0200
> From: Manivannan Sadhasivam <mani@kernel.org>
> To: Can Guo <can.guo@oss.qualcomm.com>
> CC: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
>         martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
>         Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
>         "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
>  deadlock in TX EQTR context
> Message-ID: <h5lsilzmxhu3jyujladib3w75nsute7yrkr4t5sg57nwzwb2ek@d4btnbylvrvu>
> References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Disposition: inline
> Content-Transfer-Encoding: 8bit
> In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
> Return-Path: mani@kernel.org
> X-EOPAttributedMessage: 0
> X-MS-PublicTrafficType: Email
> X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|SN7PR04MB8601:EE_|SA0PR04MB7354:EE_|SJ0PR04MB7504:EE_
> X-MS-Office365-Filtering-Correlation-Id: cf9bede7-f8fe-44b9-1fef-08dedb758914
> X-Microsoft-Antispam: BCL:0;ARA:13230040|2092899012|82310400026|3072899012|12012899012|13003099007|18002099003|16102099003|22082099003|11063799006|56012099006|19002099009|6133799003;
> X-Microsoft-Antispam-Message-Info: =?utf-8?B?WjFDT0JNbDBwR0I0UGJsVUhVUUdVQTRhUEFTTnppbjdVMlJDQjBvOWdZNWlj?=
>  =?utf-8?B?RnhMdzk2Y21GNi94aEZuUDFOTVF2clJIWjdaWlBvQ1NvcFo2dGJ5dU1JRTRH?=
>  =?utf-8?B?WmdLejlYUHlHdFI2U3RXL09vSXZiK1NZVEU4V01kMnREeGdhRnFBYmlITlI1?=
>  =?utf-8?B?ZnhnUkZHZ2xqOE84NERjMG5qRU0vYzRTQUovTUkzdE9GUzlmZTNpdnVLTDFK?=
>  =?utf-8?B?cnN6eExwMDRQaGNrbk40cmc2RUFwMHlrR1J6WmZESTdzV003UmNHYWU0TzNo?=
>  =?utf-8?B?N2FXbDN6WXJyYjdvMHdpWjVzWGNndENZY2czaXRsL01pRG1wMGZmVFk2WEZ3?=
>  =?utf-8?B?aDlyd2N3dGtzejBHVk9CakRYbXFoNCt5eWxLNXQ0Zlh1TWEwTE5nNUlQTE5W?=
>  =?utf-8?B?K3VMQmJRMnR5RkhxWFdVLzB6Z2JuLzd5M3U5S0lvWnBQcEFBWVJxVHVzOGpk?=
>  =?utf-8?B?QzdUak9oSnhpaXU2clA5ZGFqN3J5MUJjQkRwMDZ0U3A4UUlERm4xQldsUGtp?=
>  =?utf-8?B?TUY5eU5NTUhTMXRzRUl0WWkwKzNyL05sQlF1WEJ5QS81YVpXSmRudzZ3RGhX?=
>  =?utf-8?B?WmdXeTZTSVJ1K2ZPSURFZkJnZFpmUUJRcm9LeXFJNUJwYW9RalFTUC81bHBl?=
>  =?utf-8?B?N2c0Ym5vaEdxWitweUN3dDJBeUJ2b2J5TmkvMy9OQnIyK2VpWUtuSXVaeWgz?=
>  =?utf-8?B?TXBvcUJWYXdJTjRiTUY2bFA2UnNtY2xQeWUwZWc4S3dQVi8vUFBNTzJHMjVB?=
>  =?utf-8?B?TEp6TFlwcXZsanJhNVNvVDBoUWxFenFjVmR6QXBBbFA3MFBGNFU0dkszeEx3?=
>  =?utf-8?B?NlNxTGlScjFaQXBjamVmMlZCVUs3WnFyK0RXNmMzbXNxSU93cW5YSG5UbmxN?=
>  =?utf-8?B?dnVJaFFFMGpSdUtmYVNTZ0hSVEl0Y2N5dGgxbzdJcFRJSnhlZUdYOGdvL2Jo?=
>  =?utf-8?B?bUxYZmR1Vjk5NVIzODBTdEwvRG41djNpbU92dEJmWlJBQ2RRek1xL0RJdzFC?=
>  =?utf-8?B?RTRxelVRNXlERkN4N0hGUHpEbXNZR1Z4QkhrdnE1Y3BXYzYzeXAwU1JzM0hR?=
>  =?utf-8?B?cUlWbTlRYVNTQytsOWZzNC9TMS9peWJSZnJCcEVKakh1aGhRdWZ1YzJ0bmR5?=
>  =?utf-8?B?TWV6RS9oWHNYZjRQKysxbFhRZWhlKzZFVUFTamZ5UXdMVHdpcjJrc0VkTlc2?=
>  =?utf-8?B?bzBWYTYzeXI0Mk5YTFZWbk4vS0ZtL1ZBcTBhb3I3Y0o5VkVhb1R2QnNkUkpC?=
>  =?utf-8?B?TDZUUjdiVEd1VVhaMTZXR1FZai8vQ0Z1dmFUNFNSMVErTURJQVNRRWJOUGZ5?=
>  =?utf-8?B?RnVhWnVQV28zclAzVUZDSmtBVGZmMUp0VVNWMnVOTUN3d0dpZ2FMMUJxNHdr?=
>  =?utf-8?B?d0JWYkdpS00zOVRhaWJwRTR5VHk1ZU5Damo4R3JtY0I3NXdYMkJabDFHSmNt?=
>  =?utf-8?B?Ti9pN3hrcDZBV1pLTEhnU3l5NHNFcUJVM1JGbGJ4aVFRZG0zVWlzTnkyYzJH?=
>  =?utf-8?B?dmg3dHlsL0FpYmVVV1ZlWUxyN0hEWVdRREV4WjZrM2hWdHlpNGt6dzJqMTVK?=
>  =?utf-8?B?ZE9QT3pVQ25UU1hzVnVvbWxDK2NWTzdNb2FNb3NBVmdGQ0dMczJOSm1PWkIz?=
>  =?utf-8?B?SGhWUnJOOXpTTC8rVUdTa0ZzNGQ5bzYvUmV4c0Z5L0E2aUxZRnJlRTlKNlRQ?=
>  =?utf-8?B?NU1xWjFPRFpYSi9NMURDajB1Y3QrRlRIOEdDNHhpQ3Y4T2g2aXl2WVNyRENo?=
>  =?utf-8?B?SnNYSSthSmdyUmR3aWpoRXh1ZXk1M2tXUk9SR2JYazNsbnBTcHB0cjlWOHI0?=
>  =?utf-8?B?OTFEeU0vQmlQVnNvMW9oM2IwL3N4eFhkRUZPTFBpVVlPUVJYQ0kvbTg1S05Y?=
>  =?utf-8?B?ZFhLampic0J6K2FnM2YrWnhYUHJBM3RRNnlRZHd3YlU4bXpLZDArRVpMR0FR?=
>  =?utf-8?B?S3RzYmwzOFI0MGdVYUNUQUhIcUFGT09RWGVYbTRxZEJTRnpBMDhYMGR6YWdq?=
>  =?utf-8?B?MERCV3cwOXdHdDl4c0pQcXVHdVpCVXd3UGJ0U2FtK3NpdmJPUlMxUllDaWhy?=
>  =?utf-8?B?cCt2SHVpcVZGNGM1MUJMT0o3T3dSM1RaTHFxM2dsd3dZaVVQY2lONU82SHhs?=
>  =?utf-8?B?Y0hjSVdZdyszSW11MEU3elE4SFVXMC8veDNEb201MjhlZGhXTGNTTzFsbmV5?=
>  =?utf-8?B?WVZwbFgzWSt1NnZtWmlQa0VvTFd6dDY2WFJTSEZFNWgvSTFyS0Vtcnp2aXI5?=
>  =?utf-8?B?MlpwU05mQ0phTm5YYjg0LzR1UFZ0NzBETStxeGp0aHRxM013NE45TlJZL0xa?=
>  =?utf-8?B?SU9WQ0MzbnFmS0oweDdWM0J4WUlWZ05CZ3Fpc2YrMmh5QlZIbjkwTG53Q3Fm?=
>  =?utf-8?B?bXVRRjZscWRBNnVQRzFDVEtXU0ZPR1lhdTJVdnlTY2oyWlRpZEpwTkN5Szg5?=
>  =?utf-8?B?cndBYnN2ZjUzdjlES214b2tJRnpiamwxb3RhUmxYdlBJS1lqaE43UmVWQmhX?=
>  =?utf-8?B?Uk9ubXBTcUM2NXFlVmw2K21lTFU0MHUxT1ZjNE5IT2RjZVdoSHlRRXJmN0cv?=
>  =?utf-8?B?d2IvNDc5dFYzSVdSb2JFNWVST0Y4ck1vVHhFaEUvelpiSk5HQ1c0RUJxRlZ0?=
>  =?utf-8?B?eEJJT2lxbi9wWjZIRHBDYWFYVjBpbC90M3ZDZUhhQ3NwWGloK01WK2V0WHo5?=
>  =?utf-8?B?RWwzV01oNS9yZDNRSmdVUUd4UnJsRTZrNWZSbVo5NTl0cjdsakpyZ0tFckNn?=
>  =?utf-8?B?L1NORHpubEJuRDI3TlBMbUtzbHpJMkwwd24yRW5YK0tQTU56R2FKL2J2Q2NX?=
>  =?utf-8?Q?rFAHIOsQuWnoj+JZF8FomgaRDLfjahlRegIJMGEm/j?=
> X-Forefront-Antispam-Report: CIP:216.71.154.45;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esa6.hgst.iphmx.com;PTR:esa6.hgst.iphmx.com;CAT:NONE;SFS:(13230040)(2092899012)(82310400026)(3072899012)(12012899012)(13003099007)(18002099003)(16102099003)(22082099003)(11063799006)(56012099006)(19002099009)(6133799003);DIR:INB;
> X-Exchange-RoutingPolicyChecked: S/XJuRvJovcKR05qjx1Et77PuLD5ORMxqVsIDMtLDKJHw9tHBciUtjihy6H6aqIkAHjjx/n20h0NwBiEIc9RP3Ddj2sGwFeFdfSB4+VxUjbOniaw6xlibypl7oN4sZytInt+83PczzwtMSX3eRwvwz5Vy5I4kSnmiOCOLzqLje5XKXcneVDVfRvRBGIEUXxXeLX5ZLzHnTIN7krqq5Pkwo+Rf2EaA+GwdzIJK0Vrm8UCiqeMAzPpLduEnj46qNDHKAKwboVDJ4z9cH5JLwXOKrJRz4wy3bqyfBe65bSje2jzH0UbDyTo0mc8tncnQYpBt1paDfhPw57TcH6N+7EQcg==
> X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:44:59.0030
>  (UTC)
> X-MS-Exchange-CrossTenant-Network-Message-Id: cf9bede7-f8fe-44b9-1fef-08dedb758914
> X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
> X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=b61c8803-16f3-4c35-9b17-6f65f441df86;Ip=[216.71.154.45];Helo=[esa6.hgst.iphmx.com]
> X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF000023D2.namprd02.prod.outlook.com
> X-MS-Exchange-CrossTenant-AuthAs: Anonymous
> X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
> X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8601
> X-OrganizationHeadersPreserved: SN7PR04MB8601.namprd04.prod.outlook.com
> X-OriginatorOrg: sharedspace.onmicrosoft.com
> X-CrossPremisesHeadersFilteredByDsnGenerator:
>         SJ0PR04MB7504.namprd04.prod.outlook.com
> 

> Reporting-MTA: dns;SJ0PR04MB7504.namprd04.prod.outlook.com
> Received-From-MTA: dns;SA0PR04MB7354.namprd04.prod.outlook.com
> Arrival-Date: Tue, 7 Jul 2026 13:57:00 +0000
> 
> Final-Recipient: rfc822;avri.altman@wdc.com
> Action: failed
> Status: 5.4.317
> Diagnostic-Code: smtp;550 5.4.317 Message expired, cannot connect to remote server
> X-Display-Name: Avri Altman
> 

> Date: Mon, 6 Jul 2026 17:44:49 +0200
> From: Manivannan Sadhasivam <mani@kernel.org>
> To: Can Guo <can.guo@oss.qualcomm.com>
> CC: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
>   martin.petersen@oracle.com, linux-scsi@vger.kernel.org,  Alim Akhtar
>  <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,  "James E.J.
>  Bottomley" <James.Bottomley@hansenpartnership.com>, open list
>  <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
>  deadlock in TX EQTR context
> 
> On Thu, Jun 18, 2026 at 07:09:29AM -0700, Can Guo wrote:
> > TX EQTR may run while devfreq gear scaling has quiesced the UFS tagset. In
> > that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr() and
> > ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct reclaim
> > is triggered, reclaim/writeback can depend on I/O to UFS device. Because
> > the queue is quiesced, this can cause deadlock.
> > 
> > Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
> > allocations in the TX EQTR call tree, including:
> > - params->eqtr_record in ufshcd_tx_eqtr()
> > - eqtr_data in __ufshcd_tx_eqtr()
> > - params in ufs_qcom_get_rx_fom()
> > 
> > This is preferred over tagging individual call sites with GFP_NOIO, as it
> > automatically covers any future allocations added anywhere in the call
> > tree without requiring each caller to be aware of this constraint.
> > 
> > Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
> > Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
> > Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
> - Mani
> 
> > ---
> > v1 -> v2:
> > - Replaced per-allocation GFP_NOIO usage with memalloc_noio_save/restore()
> >   around ufshcd_tx_eqtr() call tree.
> > 
> >  drivers/ufs/core/ufs-txeq.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> > index 4b264adfdf49..9dca0cd344b8 100644
> > --- a/drivers/ufs/core/ufs-txeq.c
> > +++ b/drivers/ufs/core/ufs-txeq.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/errno.h>
> >  #include <linux/kernel.h>
> > +#include <linux/sched/mm.h>
> >  #include <ufs/ufshcd.h>
> >  #include <ufs/unipro.h>
> >  #include "ufshcd-priv.h"
> > @@ -1212,14 +1213,25 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
> >  			  struct ufs_pa_layer_attr *pwr_mode)
> >  {
> >  	struct ufs_pa_layer_attr old_pwr_info;
> > +	unsigned int noio_flag;
> >  	int ret;
> >  
> > +	/*
> > +	 * ufshcd_tx_eqtr() is called from a power-mode-change context where
> > +	 * I/O is suspended. Use memalloc_noio_save() to propagate GFP_NOIO
> > +	 * to all allocations in the call tree instead of tagging each call
> > +	 * site individually.
> > +	 */
> > +	noio_flag = memalloc_noio_save();
> > +
> >  	if (!params->eqtr_record) {
> >  		params->eqtr_record = devm_kzalloc(hba->dev,
> >  						   sizeof(*params->eqtr_record),
> >  						   GFP_KERNEL);
> > -		if (!params->eqtr_record)
> > -			return -ENOMEM;
> > +		if (!params->eqtr_record) {
> > +			ret = -ENOMEM;
> > +			goto out_noio_restore;
> > +		}
> >  	}
> >  
> >  	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
> > @@ -1244,6 +1256,9 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
> >  	if (ret)
> >  		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
> >  
> > +out_noio_restore:
> > +	memalloc_noio_restore(noio_flag);
> > +
> >  	return ret;
> >  }
> >  
> > -- 
> > 2.34.1
> 
> -- 
> மணிவண்ணன் சதாசிவம்


-- 
மணிவண்ணன் சதாசிவம்
