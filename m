Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3933DEE5;
	Wed, 18 Feb 2026 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771408608; cv=none; b=cJVW5fpzKdLb9tJHzi7np/x1HUlIAVF1hP0fiTaqOxBNsrL406k7vR2KcSdaMtkGmqDCQIVSs2BWIZQCtGbhp2cg4YtTrvJ6QFsoDocPc6C/b7MmCUm8cEjKjoRneMIlUCq+7UMe4hCs5O4yTdiTljlh2paVIh1TwJ/+AQLHl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771408608; c=relaxed/simple;
	bh=2M/oHwf738t/3QfICnitZIlKcPZTFwrhHKLEPVnncmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdQrYLsDp61jZZOPVbZwOvgGfBtFzDJj0bUOGMCCXHQQKQF+andAJEZ/7QNOjlv8T8KHbyUE0THRZYi7m6iRpcbu49GO+mSdkF9UNPlErTj+6zNtN8cZuIEkgpOLbnN/FEfWOPnhWB/K+ewHN5jT6MnXpkntHQoqgd1XQqAg1uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgQ128kW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgQ128kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62380C19421;
	Wed, 18 Feb 2026 09:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771408608;
	bh=2M/oHwf738t/3QfICnitZIlKcPZTFwrhHKLEPVnncmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fgQ128kWu65YDpWegMGfZb53YMJOn37hIRSVFfGx+pX+XzlqcyAlnYaoU4+6+1DmR
	 RORpysuoN+2jc/iElKEHzTyrk0kzgPds9IeF8VxQJ+oNH9GOwItJ1Z3Oxdd7tUBcVN
	 gc5Nrt9uyY/DSO/rlnEeiwkHWl3ev1N5AM2HgxyK3ZUZYnYyxqmq25m1NcF14MNeOg
	 cCpyzWOtZJzVvtGzG8/VOLvy1VOmg3CHRMe8f06ebQMRHR55fCCvgN/TodM6lois0T
	 F2PEVMj7VwCi7XlgOy78HPknik2Fxg643Q0kw2U9PSjATb6snf0OTVTdqf2Er++Lkg
	 qhpQKFaFxakhg==
Date: Wed, 18 Feb 2026 10:56:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260218-haben-protokollieren-d4b5d2a1f8c9@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
 <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
 <CAJpMwyg-3-Z=ZDC60Vn0s-8Z78VOPKYmvX9s=Nnvcoao4T5zbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJpMwyg-3-Z=ZDC60Vn0s-8Z78VOPKYmvX9s=Nnvcoao4T5zbg@mail.gmail.com>

On Tue, Feb 17, 2026 at 11:37:19AM +0100, Haris Iqbal wrote:
> On Mon, Feb 16, 2026 at 3:28 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Jan 29, 2026 at 05:13:52PM +0100, Christian Brauner wrote:
> > > On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > > > > (1) Fill out the following Google form to request attendance and
> > > > >     suggest any topics for discussion:
> > > > >
> > > > >           https://forms.gle/hUgiEksr8CA1migCA
> > > > >
> > > > >     If advance notice is required for visa applications, please point
> > > > >     that out in your proposal or request to attend, and submit the topic
> > > > >     as soon as possible.
> >
> > This is (likely) the final reminder to put in your invitation request!
> > The invitation request form closes this Friday, 20th February.
> 
> Hello,
> 
> What is the announcement date for accepted topics and invitations?

We will very likely aim to get the initial batch of invitations out the
middle or end of February.
