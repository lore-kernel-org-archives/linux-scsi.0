Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDD260587
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761802181; cv=none; b=avNhSxsTKz3jtwY4m2O6itA3mH/+HhaGQlou+AbqeatarcoTJ2MA8833ER4KBEG7RLdn7ocWi5cECa11CzMIM19fyvqMixlZyh1jAq1c7DUxvXHDxLHU3b+iw/DOrC1fEGthigHFxI4LZxzRiNnQy+bAvXZY7iZRkypxcRlkJu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761802181; c=relaxed/simple;
	bh=qYkKmoBDv3y2AFOLGMAJuKTlPQODpKt9eLPDUoUs1yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjX/Eo5TRR+b5xOtQmW4sWxQgqFd5iomDbLYnowr+UtXchUDahjcrmjl10dBgH/lEuwnsqOUQ4QxvnA3X+Mcg+OtPoeL6RSL2sbXn+yn/414pWKeiRxbXpYyZtQth3ByuEfMZ18ySkqgiWNkVTapI/VNpWYzNDqivf5lV/AN0jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZANPgs2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZANPgs2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C5C4CEF1;
	Thu, 30 Oct 2025 05:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761802180;
	bh=qYkKmoBDv3y2AFOLGMAJuKTlPQODpKt9eLPDUoUs1yg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZANPgs2uasl3mBpW0V+1x1tsu3pOZp7+3f/t1WHXVggHONpFA4npHbQoktDtn95zC
	 bIEUPOJfGW5T1q9KioG73WzeQcwmnnUIvoDos2InsKnUGXuokH7hnLvA3SlafemP7Y
	 B1Cw0Pf/HfWu/Rws58Aa7xWeJwljkrgeIc4Wf5XWO67cfiRKDw3ZrgXzbAyEfH0qBc
	 HlP4Ad+LsMeKuauZDAwdN/ruJDP12h6N9pYVMKez/kX2OeSiILfHpjdzaJ9UiDFzIB
	 BkoLrqd4cc6/Llaw0dC9rCarmZYBpReYb2Ony19rd+VAPXrwpIB1kzq2Q+Dgc61wwo
	 PTloXR19OD4og==
Message-ID: <3d435d9d-cfdb-4221-839b-ca6bd671ebc5@kernel.org>
Date: Thu, 30 Oct 2025 06:29:37 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/11] lpfc: Add capability to register Platform Name ID
 to fabric
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-10-justintee8345@gmail.com>
 <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
 <CABPRKS9qL-vNbLeE=bqtk=wodVpA2fz8WR_n_iFXS3Yey_bbmg@mail.gmail.com>
 <a4cfc9db-3c41-4b92-ab2b-17b0ed7f1955@kernel.org>
 <CABPRKS-uBAzvCN6nRLy0bteG7AKAbeMUPfOsc85_ww7=OjrWpA@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <CABPRKS-uBAzvCN6nRLy0bteG7AKAbeMUPfOsc85_ww7=OjrWpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2025 19:14, Justin Tee wrote:
>> That's not really answer to my question. I asked where is ABI documented
>> and you answer how driver behaves. Not related.
> 
> So, referencing lshw, the device tree ibm,partition-uuid property is
> used when reporting UUID on IBM Power systems
> https://github.com/lyonel/lshw/commit/9c5c2f0706db330114ff4624e0931ac40c1d6fe2

lshw is a program, not an ABI documentation. ePAPR is documentation,
bindings are.

> 
> Additionally, referencing how libnvme generates UUIDs, the same
> property seems to have been chosen by IBM as the basis for NQN
> generation as well
> https://github.com/linux-nvme/libnvme/commit/62bac64627b7ee99c49f30a399240acf04c95d92
So you never defined an interface but you use it? Sound like that. And
what stops us from changing this property here to anything else? Like I
wanted different name? Do you understand what ABI is?

Best regards,
Krzysztof
