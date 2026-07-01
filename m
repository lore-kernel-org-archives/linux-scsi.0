Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB747F2F0
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782906221; cv=none; b=DQ3ySZee7blWlUFn/Kre6UECykJ+ryltmYZxMw64n7IAr4x93OA9wSK+VyxNPa0x6FHc6sZ/gAulAK4jJid8ZfJq8/Ir4qQa4/z7Csp6MA+l3kNv9gDwNsiu+tiX+w0fa4o+wyfVqiS52wJPynKbf2WdLUMPK0aBjNUCtxNs6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782906221; c=relaxed/simple;
	bh=vOkaF3KQVviYyUGRvSbbWPkWhyXuJod98w4hXS2qzx0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GeULF2SkaJmwnzyHE2FeWjT5mSpZTIxVFucw1DTq95iKpFQ8iy2SEBywIxQANYEPURMY+EaYzJ+A6Rd9AN1O75vD429bT0ZY9zHiWvgXhg4AeZoP8cykP4iNI7Of39CNcSQv8gPDC63VTVAW3HcKH8cs1FDMnOW+uV9zpqa7Nxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 371E768BFE; Wed,  1 Jul 2026 13:43:36 +0200 (CEST)
Date: Wed, 1 Jul 2026 13:43:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-scsi@vger.kernel.org
Subject: [ANNOUNCE] Alpine Linux Persistence and Storage Summit 2026
Message-ID: <20260701114336.GC17996@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

We proudly announce the 9th Alpine Linux Persistence and Storage Summit
(ALPSS), which will be held September 28th to October 1st at the
Lizumerhuette (https://www.lizumer-huette.at/) in Austria.

The goal of this conference is to discuss the hot topics in Linux storage
and file systems, such as persistent memory, NVMe, zoned storage, and I/O
scheduling in a cool and relaxed setting with spectacular views in the
Austrian alps.

We plan to have a small selection of short and to the point talks with
lots of room for discussion in small groups, as well as ample downtime
to enjoy the surroundings.

Attendance is free except for the accommodation and food at the lodge
but the number of seats is strictly limited.  Cost for accommodation and
half board is between 73 and 92 EUR depending on the room category,
with additional discounts for members of an alpine society.

To attend please request an invitation by mailing your favorite topic(s)
to:

	alpss-pc@penguingang.at

If you are interested in giving a short and crisp talk please send an
abstract to the same address.  Attendance requests that propose a talk
will be prioritized.

We will start sending out invites on August 1st, and plan to publish
the official schedule in the beginning of September.

The Lizumerhuette is an Alpine Society lodge in a high alpine environment.
A hike of approximately 2 hours is required to the lodge, and no other
accommodations are available within walking distance.

Reservations for the lodge are handled as part of the ALPSS registration
and do NOT use the usual lodge reservation system.  Please let us know if
your require vegetarian, vegan or gluten free food or have any other
dietary restriction.

Check our website at https://www.alpss.at/ for more details.

Thank you on behalf of the program committee:

    Christoph Hellwig
    Johannes Thumshirn
    Richard Weinberger
