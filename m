Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795095259;
	b=QU2o5iJVr3ORba7GP4csB6pzpXkaEj8AeaNheIXuQA+e6GYNRTphtZGMjHDnujuC16s6
	 FyImgV98KRwE4cb/50Rr7js0j4qa+IdT8fsiGgHN0MsM4RYQD6wEKulwrc1RUqikjLM3H
	 GuXapOOrMc8cAMc+MaCyrGL1iKCVDJu1krB8Sk6cGiN0xMKQFQdVS4oVaGGzTHdmiYBZz
	 IZMHD5q4WGpDRCLjzFHGsfJQY0S4ctlwlg/rVQ9Wnj6bwu4X2ID+O9hOefNkDyLYdmJYZ
	 q0AgObOqsX/hI8AzZqvF1iaO+jLc7LlxiL9ZgWIEX0yp31EB+TGa0NKMmNbf1q1i2EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795095259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=ZEhJOzyXKju3tKMEHQwkNUXNp0T51VucdQQfkmvqiQM=;
	b=EQj48L4yjFUZFqABGaYV0M+Thbr/SMDvI98bH4a39EfjdJ7ronMfUI0T9q1HVR0pbhjp
	 uKsVdXBZ8cGf6Kgt52+62mWm0tsSwR9IyvTcP31inEI9uAOtrvIXcm2tPfvUAx1PBZzKo
	 +I6/SeYFpii8090QAIcIKJ8hfLhQ33yVUqmbuki56NksQ6R7Tnpx+vB/FuIJ4l4Hhlt1i
	 qFc1FcyoxU4SWBLd9TYGpx/H9knTxq1vfR66IJXRYS6E2sPH5z3tgZvQedQAUpuHxm7EB
	 s8mM9tHlqoWIn91XwywgC3yB78t8YbXgkMjv3R7hqMHKdui9PS5fj4r3GEEG/wm9YPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GrCxvm/1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3144606A324;
	Thu, 19 Nov 2026 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrCxvm/1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FAA1F000C5;
	Thu, 19 Nov 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795095258;
	bh=ZEhJOzyXKju3tKMEHQwkNUXNp0T51VucdQQfkmvqiQM=;
	h=From:To:Cc:Subject:Date;
	b=GrCxvm/1lTIpcplkRdycUOpd8LVxmcPVO6UlPCcpghV8chsq66wX7A7O7TxLup21a
	 pWIcbGGSrVmxkJTuFAJgNiOVC4ou3TGAx8Gmgh2LFsrtjcM1eYJ/sqRT7p+z09a5Ku
	 +FkxP7Y4U+dV7F9m3UXNaWI544KdtoU5vOTRGSbMCrIrWYHK7h+NtQUXQHr/IZaZjM
	 qv0yO2QAK4wQBVFeiYu7q0dMivT1CnGyBlmaULCWxP50XnjNFaACPP/IEUAgaYRg2e
	 1uX5zf32+m1tKzZO5Hsp1MBL8GjysMxL372SXHLPLsPpadYgh/NfVjrC8Bx5G//qwU
	 Soeyhs3nmUgpQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	bpf@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>
Subject: LSF/MM/BPF: 2027: Call for Proposals
Date: Thu, 19 Nov 2026 14:33:58 +0100
Message-ID: <20261119-lsfmm-2027-cfp-b7edcf7eee48@brauner>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4868; i=brauner@kernel.org; h=from:subject:message-id; bh=cENfH9cFzvlCJSmEwugWKvbkFTl+BgVyZRO6iqPrl+M=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9+3VG1DDxxd21Poei9nSxHb701fr/tFS26NI9pTvER DV/vPD37ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI/X+G/2H/jtyIlWyy/Kzx pkTjrv7suc3aO9J/f7a59nzzxGs/iw4xMnxfnLzy8SvWLZstLi0+oXpXekH66ZjLC5b3zF69ztR vrjULAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

The annual Linux Storage, Filesystem, Memory Management, and BPF
(LSF/MM/BPF) Summit for 2027 will be held April 27-29, 2027 in Porto,
Portugal.

LSF/MM/BPF is a small, invitation-only technical workshop for the
people who develop and maintain the Linux storage, filesystem, memory
management, and BPF subsystems. We get together to work through
problems and to map out improvements that will make their way into the
mainline kernel within the coming years.

The summit runs for three days and has four subsystem-specific tracks.
Topics that touch more than one subsystem get joint sessions with all
affected tracks in the room. You're welcome to sit in on sessions of
other tracks too. There's also time for BoFs, hacking sessions and the
hallway track.

The sessions are supposed to be interactive, inclusive discussions. The
discussion leader outlines the problem and then the room works through
it. Slides and visualizations are encouraged but please refrain from
lengthy presentations.

The agenda is built from the topics proposed on the mailing lists. The
discussion a proposal gets on the list helps us figure out which topics
are important. The program committee then selects the topics and sends
out the invitations.

Attendance is limited to keep the sessions productive. When you request
an invitation, please tell us what you'd like to discuss and what
expertise you bring. We also want to make sure that people who are new
to the community get proper consideration. So if you're a maintainer or
have been around for a while, please nominate newer contributors in the
form.

LSF/MM/BPF is an in-person event and we don't offer general remote
participation. If you're needed for a topic but can't travel, let us
know and we'll try to find a solution.

Important dates
===============

    January 27, 2027    Deadline for invitation requests
    Mid-February        First round of invitations
    April 27-29, 2027   LSF/MM/BPF 2027 in Porto, Portugal

Venue
=====

The event will take place at the 

    Sheraton Porto Hotel & Spa
    R. do Ten. Valadim 146
    4100-476 Porto, Portugal

Do note that for this years iteration it is of the utmost importance
that you make use of the Linux Foundation hotel block.

All further details are availabe on the event site:

    https://events.linuxfoundation.org/lsfmmbpf/

Requesting an invitation
========================

To attend, please fill out this form by January 27, 2027. Proposing a
topic on the list without filling out the form will lead to us discussing
it without you!

    https://forms.gle/hhC9zXMsAJCR2dda6

In the form, please tell us:

    - what general areas you'd like to discuss and what expertise you bring
    - whether you need a visa. We handle those requests in the first
      round of invitations, so please don't wait.

We realize that travel is an ever-changing target, but the requests
help us get an idea of possible attendance numbers.

Proposing a topic
=================

In addition to the form, please send each topic as a new thread with
[LSF/MM/BPF TOPIC] in the subject to:

    lsf-pc@lists.linux-foundation.org

and Cc the lists that are relevant for the topic:

    FS:     linux-fsdevel@vger.kernel.org
    MM:     linux-mm@kvack.org
    Block:  linux-block@vger.kernel.org
    ATA:    linux-ide@vger.kernel.org
    SCSI:   linux-scsi@vger.kernel.org
    NVMe:   linux-nvme@lists.infradead.org
    BPF:    bpf@vger.kernel.org

Please use exactly this subject prefix so we can find the topic
proposals when putting together the schedule. The mailing list
discussions will be linked from the schedule so other attendees can get
a sense of whether a topic is of interest to them.

Previous years
==============

LWN has covered previous iterations of LSF/MM/BPF extensively:

    2014: https://lwn.net/Articles/LSFMM2014/
    2015: https://lwn.net/Articles/lsfmm2015/
    2016: https://lwn.net/Articles/lsfmm2016/
    2017: https://lwn.net/Articles/lsfmm2017/
    2018: https://lwn.net/Articles/lsfmm2018/
    2019: https://lwn.net/Articles/lsfmm2019/
    2020: 404 - Cancelled by The Plague
    2021: 404 - Cancelled by The Plague
    2022: https://lwn.net/Articles/lsfmm2022/
    2023: https://lwn.net/Articles/lsfmmbpf2023/
    2024: https://lwn.net/Articles/lsfmmbpf2024/
    2025: https://lwn.net/Articles/lsfmmbpf2025/
    2026: https://lwn.net/Articles/lsfmmbpf2026/

Program committee
=================

    Kanchan Joshi      (Storage)
    Martin K. Petersen (Storage)
    Christian Brauner  (Filesystems)
    Amir Goldstein     (Filesystems)
    Jan Kara           (Filesystems)
    Vlastimil Babka    (MM)
    Matthew Wilcox     (MM)
    Daniel Borkmann    (BPF)
    Alexei Starovoitov (BPF)

Thank you,
Christian Brauner
