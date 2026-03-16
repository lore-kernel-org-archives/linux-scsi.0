Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADDD35CB8C;
	Mon, 16 Mar 2026 21:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773697557; cv=none; b=u+PnAQuboyAeDh48TpCoTZ9TVi5oDYKbq6M9GmzlMSAYazgLPojdU9FBH86IuBNVV5BpTq51LK+UbhMPd4I9yfF75gj0kgfeQ3hGeJ6HMk+lz5cte6oGzJw9RbhNbdicCf2QGvzlj5GBuPDm2tHAG57rhu3n8ClywFh2WUTJtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773697557; c=relaxed/simple;
	bh=/UyC2rv+fuf1B8esy+O+vyfPhSfBzfj4uOXEAJ8jSnc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Savz+Lm6QpTQQUSWKV6DJsI6Cnni6rEBjhFryhb8hdBEEzq7ny1XvnuVC3ahUcWP8KAKpk75YNd7YwxISDut2qoJi6YnZU9/wmQ5CiYTtxn9XdvrkKorhLfKQXWb68u2qmoQcJ20Oon4PdgEhhmWZp6QO816WBj02PjeiiyzEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id DE7AC2C14A6;
	Mon, 16 Mar 2026 22:45:45 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id gGqg7UAYOlZ6; Mon, 16 Mar 2026 22:45:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 3AEF62C14A8;
	Mon, 16 Mar 2026 22:45:44 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q-DUhqY-5-xt; Mon, 16 Mar 2026 22:45:43 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id A7EA82C14A6;
	Mon, 16 Mar 2026 22:45:43 +0100 (CET)
Date: Mon, 16 Mar 2026 22:45:43 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	mcoquelin stm32 <mcoquelin.stm32@gmail.com>, 
	alexandre torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	linux-hyperv <linux-hyperv@vger.kernel.org>, 
	linux-stm32 <linux-stm32@st-md-mailman.stormreply.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	linux-staging@lists.linux.dev, 
	linux-scsi <linux-scsi@vger.kernel.org>, 
	target-devel <target-devel@vger.kernel.org>, 
	linux-afs <linux-afs@lists.infradead.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, ryan roberts <ryan.roberts@arm.com>
Message-ID: <305430349.46051.1773697543461.JavaMail.zimbra@nod.at>
In-Reply-To: <e3071ae43af79277d3919bafb71f009694d0854d.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org> <e3071ae43af79277d3919bafb71f009694d0854d.1773695307.git.ljs@kernel.org>
Subject: Re: [PATCH v2 09/16] mtdchar: replace deprecated mmap hook with
 mmap_prepare, clean up
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF148 (Linux)/8.8.12_GA_3809)
Thread-Topic: mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Thread-Index: pNh82O8fJN+FJCj96uoZroIJd3hL7Q==

----- Urspr=C3=BCngliche Mail -----
> Von: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>

[...]

> Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commente=
d
> out the CONFIG_MMU part of this function back in 2012, so after ~14 years
> it's probably reasonable to remove this altogether rather than updating
> dead code.
>=20
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> drivers/mtd/mtdchar.c | 21 +++------------------
> 1 file changed, 3 insertions(+), 18 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
