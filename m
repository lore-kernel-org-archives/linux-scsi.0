Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410825;
	b=uxnZvafcgZHdU5AuwSaxSSLW8tZ5Tx/6ASZtOs7lKUd+qePCpGUEmpayQ5c8ZASjEnNG
	 3VW0vSgyF6AFmzFWV1oFWSLHfyeBsRfK01H+5iSC805+nWJ5fJ0bVuCX4Hu7YlZ130wTw
	 IrCsWENXIMXkttCgmiWVXbYM3zlKZcNHRgQS4Cas3vwzWTUEtgKHeR5cfDjQwtczvs5QM
	 hsAO+m/2TBm2csvBx96TqxU+WX2uZuPkRB6ZzfNgY8ARqqBPhn8ZhJh/hj+yyOdOleOYg
	 45xr+QCQdWBOHne7Rylp4+keNtcfCYpAb6YPlLYF+dDkwI02yf0UvQsu32pQPUr/dSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fw/Ph/kohbFU5AYEhVaIaWTjk/GWqMVAXnYUbUWLbJU=;
	b=tymZPkDocYrefabb08sV+P0H3vcpaR+U/6BBy9C24ghtkUp4BzuALgCLjaVGyheFPnNV
	 DIqFpw/tDZ+GAHg+U0k9WH96cCq9PZrY2ejdaFlOyJOcrlc0fKA+DM0KuVjRvoRXQZATn
	 fn6SR5wk0Q/hXqTOd47ASOgZnMOQBwFQiQFGEVybzk07pEUToMJTj7jgximMqVV8rdwJW
	 QqZ66xHrja/HA7SS3/fPKd2bXsIQM35kV6Sr6QcsENiYpP3OoLDJ8CQ0HsEMDq7FXHyjI
	 jcUQbx2LxLQ3LL0uZNZBILkcMRMGRuLaKcPzK3FYmMnhTQU76jfRDUP+N2iggtvll7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gE6WcBO8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FAB606A320;
	Sat, 31 Oct 2026 01:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gE6WcBO8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A091F000C1;
	Sat, 31 Oct 2026 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410825;
	bh=fw/Ph/kohbFU5AYEhVaIaWTjk/GWqMVAXnYUbUWLbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gE6WcBO8E5tWoFp7S1yGc/qECRS4fY9KYUJ77YORfgpKWvHO80cX0tf1bNOK0jwA0
	 iyLaMv5eMxwP1QikiN2254/5IRUdXtJKD3JCq3UFpI8AVIMHPF9KC1e+I1mQUnKYT7
	 DsEJ5IySmhg/lhHXkbyz6fW72tvbLI5kroe33WrQAikZfPxucJc/N4q8kkxwYAeJh9
	 MIwGtBSGzfIrrL8dhEZ78POOXPzrDpuD9/S0wQfPlew4HGhggNr6nofVCdUiaE2n+N
	 XPCdCYWrRcLnnHTWLasmjaTCwskP37we3QAdCwYhXJa2VAE7TGfian+i4cagTxSSqE
	 nzncrj23dB6aQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Hannes Reinecke <hare@suse.com>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	Imre Kaloz <kaloz@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Fri, 30 Oct 2026 21:40:10 -0400
Message-ID: <179340755627.952351.15831662600930147004.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026131432.26065-1-kaloz@kernel.org>
References: <20261026131432.26065-1-kaloz@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 26 Oct 2026 14:14:32 +0100, Imre Kaloz wrote:

> The SGI O2 firmware runs its onboard aic7880s without the Adaptec BIOS,
> so scratch RAM holds no settings. The left over BIOS path reads
> uninitialised bytes, and bad parity panics the boot.
> 
> Use the defaults there with host ID 0. ahc_init() keeps the default host
> ID ahc_pci_config() chose, 7 on other PCI controllers, so only the O2
> changes.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
      https://git.kernel.org/mkp/scsi/c/696bdfc58975

-- 
Martin K. Petersen
