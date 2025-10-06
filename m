Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A0613957E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716561; cv=none; b=Kk5Yt2tpTDBW8y2ilB4uoT1f71qQu+jaJk+fBwo3WAeCWWHYs3iD4UEOUIE7DMpYgadudIbRDEGl1VgVGLmpiebfbBMG3TZoNJZBTGu4vKct1RLlEWwT2dkyvukbtw9lTeLEzcLvMgKb23sDJ4I+HYNaqUtW3RYMnaTKJUMg04c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716561; c=relaxed/simple;
	bh=qxStQC0JAtCNWy5R49FM5AxFhvDKabMvNoqZ24eLHz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gMRjYym98qe/Ofq1oc3qX49OrQ1SJHBiBDzAzJwLE97kscZEC8j5RvR34Jb3j07aiHbxgVPProkjaxObgRi1jayLGKB2EfkPDRpzCxFzYUr5vuBSb/0yHxgydJWLhasREkcyPOBKRJpD4BlMHzcCL1pct0MSt4u1wxMOC1DpCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmDUF1PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmDUF1PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DFDC4CEF4;
	Mon,  6 Oct 2025 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716560;
	bh=qxStQC0JAtCNWy5R49FM5AxFhvDKabMvNoqZ24eLHz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jmDUF1PRclSV/J7N4iPNPlpI6yhdF/P+R7W+95QJg55U1wTfcmH1ZgLl0aq8GP31j
	 4vS0CVIQeImzqBFuUiwl+0xewVZFoe8lcwjO47erDShmMNZ0jpyhH0z2vaB7PX6dDa
	 suhup/jZrmfTPGsmmwEtg8l6IBs0WECMaW++dv1IENQCAld+pknJA6Ng5NGdyLdSZ8
	 5BwUh5x6IjainzQLFR/+1QNNwMLQqZw3SwSzo1WNjBXN5DCRIuzn4lWDKqhyk9jh7p
	 p8AgDWPAbYnqb2AgkkRfATfE1eDyOPW0eXAotEMeCHWyfnjNT1o8mEGGEVLcD7mbkP
	 f4ndZCE5U+jWw==
Message-ID: <ed109d52-f3f5-49d2-9db3-200e999bcd9c@kernel.org>
Date: Mon, 6 Oct 2025 11:09:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-9-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-9-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> This is used to test the earlier read_capacity_10()/16() retry patch.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
