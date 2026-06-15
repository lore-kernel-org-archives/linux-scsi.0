Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC8833F589;
	Mon, 15 Jun 2026 10:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781520240; cv=none; b=hsLoJJixZ0Qgec613m6aC+7saPaE9ruA3KZRB0SUCQ0mIbXQgNZed5UhgGqunMqze6+T7xn1Jani8PNq42xeBq29yNBhbl240YXFQ9mVM0wNLTYltNFWC7R7MJVDdbJjBL+pHpgpiCq5OBbuRBdSZy8FqUTZW6CoqapObB0+Sn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781520240; c=relaxed/simple;
	bh=CvHuvUq3VhVxKI+huI73tbZ5If/qKqZw9tNL5YxdXWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AD2s59sOipOQg6KFI8CbJoLb7eu1sVKunYNCuvibi8/M2rhNsBjACEdTaOOYlOp+jW7tqYnMtB1pOSuHZn3W40tJes1l16z6dGveLvwy4W9wN38w0ZoS+QStHeo4A6TkoxCHTApdAeqyx7dWbfc6vQk6KXPLoJaWgFmUkHOJrG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1wZ4ey-0000JT-00; Mon, 15 Jun 2026 12:35:16 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 66FD9C0650; Mon, 15 Jun 2026 12:28:02 +0200 (CEST)
Date: Mon, 15 Jun 2026 12:28:02 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 2/5] mips: Remove remaining defconfig references to
 the pktcdvd driver
Message-ID: <ai_TsvPSc6dUt2-X@alpha.franken.de>
References: <20260608-remove-pktcdvd-references-v4-0-72f88b04cc87@gmail.com>
 <20260608-remove-pktcdvd-references-v4-2-72f88b04cc87@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608-remove-pktcdvd-references-v4-2-72f88b04cc87@gmail.com>

On Mon, Jun 08, 2026 at 05:29:17PM +0300, Catalin Iacob wrote:
> Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind some
> CONFIG_CONFIG_CDROM_PKTCDVD references in defconfigs. Remove them.
> 
> Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
> ---
>  arch/mips/configs/fuloong2e_defconfig    | 1 -
>  arch/mips/configs/ip22_defconfig         | 1 -
>  arch/mips/configs/ip27_defconfig         | 1 -
>  arch/mips/configs/ip30_defconfig         | 1 -
>  arch/mips/configs/jazz_defconfig         | 1 -
>  arch/mips/configs/malta_defconfig        | 1 -
>  arch/mips/configs/malta_kvm_defconfig    | 1 -
>  arch/mips/configs/maltaup_xpa_defconfig  | 1 -
>  arch/mips/configs/rm200_defconfig        | 1 -
>  arch/mips/configs/sb1250_swarm_defconfig | 1 -
>  10 files changed, 10 deletions(-)

applied to mips-next

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
