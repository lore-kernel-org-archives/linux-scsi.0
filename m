Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653121A9F85;
	Fri,  4 Sep 2026 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482335; cv=none; b=fNyCiKhlZBvxEEQF+8WIpdVCxonEWgjvRK6Ypfh60TZiEFcceW/TQyMcOYYYfKnv2MIbEXEXuAIWkSeh/CwFiZr95i5iH6JiH9WBwV+1c9XMlvWu0Zm2QKRw89UcL0vT81V+/aFDr38H4RuGsjEQAazSYDuV2dhXUbDPOy5ekD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482335; c=relaxed/simple;
	bh=B37UFBJ7SGhdgZHwAMnVhQLNBTm4GU2Cc200XD2w3+o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CLFChgnkVjSG4n8LIcCEns/9Cp7b965XXlQl59JYdeBeRjQr4rwo8b+UNRg3evopo29PZ/oo4Bjs1LqH21PJwGa+mPrFn93JPfzA0mD6IdXeqoWatu0YwRQDqyJoaMGi6HWzoNtVZWV/L05XIy6MOJHGdIvSbQ38Buw4dQQBSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inqvtVf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inqvtVf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751EE1F000E9;
	Fri,  4 Sep 2026 00:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482334;
	bh=B37UFBJ7SGhdgZHwAMnVhQLNBTm4GU2Cc200XD2w3+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inqvtVf/uDnI7KNW6wLR/kM7ZmQKN8ffdiSPmtFsxcCTBjFvpIZfLKFi+23XWCENT
	 5AoxOusBfjeNg3BmUE+3tgPiy1ECg4g8eQLxluVNiEY+PmveRr+S/kjptILzvdPsFN
	 hUOJJ5Q34skqduxixoo8rbiNJfLQDd3mXtHlqTA/in85udnzFeOyY3u7hbiIz0emla
	 0Rxl0JppTrqYGHf99nEh8jnl0wvYFUVhJWFgohxS+LILquiuYVKphi9cascrULb+18
	 Svbthy01ifl5Qso+WqOE909G86dOP6meOK6qCpma24Wx/WG0lyqTdbdLM9E1EP0SWl
	 Wu13Ip/xhIuFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/40] scsi: constants: rename internal struct field
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260904002644.157668-4-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:38:53 +0000
Message-Id: <20260904003853.751EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D3

