Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53C919F103;
	Mon, 18 Nov 2024 13:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935147; cv=none; b=jjDKIHImQmQesFNie2aNXo6Px/Ay1ke/z8HpmlcLuyXj9mf+A5+mScmxE2PhcMDOJ61NtoqFn68BSUhuM1Hv33yXAOVMrBFzXphn/vIEYmkB/Lwgp9CZJNumVnifXwqY1kttaLlnOT8QibJ+BrFNm7AaSlLxR2yz4z23DYRkHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935147; c=relaxed/simple;
	bh=LJh0j+2v8Tr0oL6457rFlEYXiIdQLydd7fS84seABc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ir1sDc6ECoYicFStUvPb9WW3hWFmY5AjNXJnUQSBlf7RU0JtEbcj12g6rQdK1sjAaVhIoNAoP9yBr8ukKvnCbCJ8d/jU+faRt+vEYSKXKmrMwgbabdS8K30gZpTu/RKHtcKYgAwwkdijVUQIVifZiCcMfbS5GieUV+qOEbdYrOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C68E68D47; Mon, 18 Nov 2024 14:05:41 +0100 (CET)
Date: Mon, 18 Nov 2024 14:05:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
	Hannes Reinecke <hare@suse.de>, snitzer@kernel.org,
	Ming Lei <minlei@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Ewan Milne <emilne@redhat.com>, bmarson@redhat.com,
	Jeff Moyer <jmoyer@redhat.com>,
	"spetrovi@redhat.com" <spetrovi@redhat.com>,
	Rob Evers <revers@redhat.com>
Subject: Re: DMMP request-queue vs. BiO
Message-ID: <20241118130540.GA29045@lst.de>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com> <20241104073547.GA20614@lst.de> <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de> <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com> <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com> <20241115170924.GB23437@lst.de> <e48b533d-c28a-4e92-b459-74820957ec7d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e48b533d-c28a-4e92-b459-74820957ec7d@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 03:28:03PM -0500, John Meneghini wrote:
>> And, as pointed out in the private mail that John forwarded to the list
>> without my permission if we really have a workload that cares md could
>
> Ah come on. I deleted most of the private thread....

As a rule of thumb forwarding private mail to a public list is never
valid without previous permission.  I'm not worried about any actual
information in this one, but it is still a breach of trust and privacy
expectations.

