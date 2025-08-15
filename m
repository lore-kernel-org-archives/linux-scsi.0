Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE6B29D286
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225112; cv=none; b=ev6iC4clLpm03kkzJQYufVxEd4Y95XNSlnBTtXKB+XcufsjUlGlBlT1qMi/PiW6yEii/cE0o/Yj2cTSpLq0AiiBkpnuSE4JrC6Jalf6vXrHU+QJopGXW7idTFZ81sT+KlpPiKWRfIYKmA7HnSmM3imSDdCeno6f1ahOOdb5yY+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225112; c=relaxed/simple;
	bh=SAgGV4IsFeyvGnc3SmSDzjj6mXwJTYXz3mD5xh8Lp6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nB+OcgYN2oRT52b8hJA8Jp697KXQ7Js6cgZy1FCOSHsFDntmRscvOd0o8b5gWrGFQpCybVUa1Yaoi3c39MxPq+x61n4oJY5RsVhvK18DTIz5dBL7ifBwAa61E78s1DqaxcYWpM2Ey6mE6KfqqxTGV6SLVrEyoQacD/7gs+X5DeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbiJg+XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbiJg+XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F30C4CEED;
	Fri, 15 Aug 2025 02:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225112;
	bh=SAgGV4IsFeyvGnc3SmSDzjj6mXwJTYXz3mD5xh8Lp6k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JbiJg+XOBspsmZyu+lyIAe7+IoVLjJKAQOSuTMK2o0KqoMKbJu3W7tphHEvC2c8o0
	 jNwLQJcToq5cYgWp7GuWXl1IuSCqj8UDT02shmtQsE0o8CiCmgNUAFHhjx4am6lY1x
	 ezUr//eu/dXbtjWjyaL5QyoVXbrX2rNVDcMS/Ey4iWUL8jmuj+sVB32fxjTSwAP+y9
	 1diU4oY98pHhV1TUXdNtm7Silfmu/970brcitusxonBe1ayCBVFVQARDfOEkLIgezb
	 5RIWwJQFLbmDoJ6A1/EmCjrvfJ4KBYBqhXJYv2+E/Az3YEOF8axS42QRU1sHf/mE0m
	 OOxhmbwuv1R8Q==
Message-ID: <ac0ba5fd-16d7-4f86-84a7-af6694c8e46d@kernel.org>
Date: Fri, 15 Aug 2025 11:31:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] scsi: hisi_sas: Use dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, Yihang Li <liyihang9@h-partners.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-16-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-16-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
