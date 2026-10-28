Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212949;
	b=kV186xFvhkEHDmmKGC57P719Hz3tbp+77cCIKq3YQK48xty35B59uW2VVlSpukd54iDT
	 l+YLfCGqn4ECIsz88R3AEUN1UcDRiH3ChcwvpGkris/E9Ghnrd5l0qUbyjcqbfl0V154n
	 1k9JoaGSFKG9KndS2tw3nHT5bGH4aZX3Ly01XP/d3Cvj9kt5nhf3e4PwTfNwTPYzy9Ezz
	 reG9IZpSeOAkegQiIpmbn6moGqiypr29tLFSr/hth5yPIL2nt5B/zi0AsZgnqxtiV40Qq
	 iNcPTouBbQXH3xxupRQcQJEd12WV7vspX7XlK/EG1vFiRanm3lsiFMFJ2IFxmhXzkVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212949;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TUhSYYrOaYYIwyOUvGxg0uWrnMWHKCpbrlmQkz/UjjI=;
	b=b8J949J/LdGZFRla+eST4vzC18UePbS3R+Hy1KnC4gk45RhuHZmHietU4gNbMulGynJ0
	 buZk6kj+6uKneUsDDdxXt1Llj7jWLgHTxGechsuhx65z6LImz/EqorgEMObSbP7D938ts
	 4/+l7ZURH+OvgqWq/PGVBXvblwym9sJHE/vQqd8eI2PtB5l57fQeeDF2LQs30/y2tH1hE
	 TvqYn3wCUjHu+q6juQJ3fAk1D/VmnKCZsdvGW67cj7DhUbUo4ESStKwRCJdFcDLExIrQS
	 aItvWuJQUIUagAq6TdnbJ/Piel50Y2xdRljt2zGbMdjpSa+yedjNGZcRuW4xOfwhRqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=SmBwarZv;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D0606A320
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A2D0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=SmBwarZv
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso1541348eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 11:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793212948; x=1793817748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TUhSYYrOaYYIwyOUvGxg0uWrnMWHKCpbrlmQkz/UjjI=;
        b=SmBwarZvelrM9RvtNSd+mFgr0zxv+G2MShThD6bpxOTAR8Lm7oPJz3BXOSnTRXpkbF
         +yQerXWD9tOGD4RsATYscdTDLdAjhe+lkznevSTMEK4tWiLaZYg2vwNafq0iwlaueMMR
         eRAav1tQBvQoAQ+Zfgti8wUV91GfazG1eQAjNTKcaWAt5nWZ9uSiEYNmd5Lc4db4xK87
         HJxhj9gpM4d5XoadbCOaaHI3KnT059olTS5dag2MgnnbczKvAz2uswSe8AZc0tV94J1Q
         Zs0NtIWdSwY/B+oao7SYP2D8TGirNMltQR1csHKbdfT/HECc2XrkJJVO+6PCffXTrREz
         ZT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212948; x=1793817748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUhSYYrOaYYIwyOUvGxg0uWrnMWHKCpbrlmQkz/UjjI=;
        b=JEqM7v5wPRs7lq5BXlniYr4p5IH5Rx9PewkBbUVcgsANgSxBMFimF070DVhBMdzhby
         1jRv3vAlZu7USsoCzRae/qmrjACBdwUF4oRYqrV0r/6d+AaQsPUDg6F1hV5Emm+mWxQ7
         8R3PHwvqBYk+uevXnKu262HLFB7JXoJKBNhZtKts0D2PyLS0BCRn8V3G8oe2Zp6WLiOs
         jgB3skIgbRo7miUd8EohvZ/HrjWjpwdK1xjoaOuqFNR6/NUeLma5HTd49KWXV702JYwL
         lfpGe1G4gWjdYQVzbaQCNh0s2i1JMAKhv4CtmWFyDSyhjkj3jnm2Ac4syQ5tGizPraAS
         dVkg==
X-Gm-Message-State: AFq9FYKpqPR1QefU0/meQlSnRRKcGo6A0aIaCeRZPawuILyNnsNZwwQr
	axLRVp5+H6/IqUmpbDnmRapLb+llZjQAJvv94UgzjrdTZEkZasbL2ksJuvky143dtowrBuEMzKm
	ZTALTULFUaAx7HdNj7Ra2H4PrrjxTSzIT4IfwxiqbuKA6eN9xW7jJo6giyIUbzm1HIML6g5xpJZ
	AwTdCfAkt1yV7OJZ34wcpVPfTutciNBRHvqQ4nT20seMwVuYaQ4w==
X-Gm-Gg: AYBFou3ms1ml7YCkmw9GqfyQDKWSdt/HRmPPP0iR22/iSwndnBhFxoVXoJNG7y+b+dm
	QCcbHjzSKyBaDNB6aqPYM07k0vmLipkCmDN9Srjk8HZXgIaOWUs6X6E3kEHijV2i8R7HRynSQ+x
	Cj9ChiIZsHqOvG4dpnwuULJl8RAOyziMekprp6/tdmS60qANZzmeYqTIaTzCsUMp35Jd/ho6E3s
	tVdI2bcepfTNS+AsZicfjr131g+xRep/WiwGzyxSJJuBleN/II+pdLrQbQMi4cUULteEJ6SipTA
	n/btjhlkQhZXZklK7iCNNNI78kmDvhcTG9BOBYLlgK0rZ3Ltblp+GhDZgdEhXvvHYLUPo3JdgTz
	UYlG4iraVOynNlhJiDijW1Ax0W7an74pURZg3KPzzJ1O8mqbZL0j8qtDXRA214hfX0uZk28dFdP
	Tsx5FQdxgy7W48Xbb5qVrD/xm+KHNjpJcIDr73Lp4NRfDwlykKxr1c6MAgRVv8IS2Bw9BF0ybzX
	uv0Mswp+Z0V9ELupyzDiUQczDwGqa6vLAI89IeI5nROuFyWv9VpyFPV1F0gCIQ6wctHr+/SC1iN
	aRMK+2S7nx82C4upyWB0SEqobb/koJTSPe18XB4nnAU/a/EpWSIhJtJXTeq2vwpqPmz5yAjxVSn
	8j73dbVtYIPfXlAmXtsZtaW2yLtCMj9/SGFRx0h+nThdwOU4K+Pu/lYzvapQATA9DAA0mXAXEg0
	fRXpAZnfMbIefdEaXdGE1vIl1cGig=
X-Received: by 2002:a05:7300:ce05:b0:369:fe81:a575 with SMTP id 5a478bee46e88-36a201638d4mr3943925eec.35.1793212947147;
        Wed, 28 Oct 2026 11:42:27 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da3e1sm11604066eec.8.2026.10.28.11.42.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 11:42:26 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 0/4] scsi: Bind sd to LUs in the ALUA unavailable state
Date: Wed, 28 Oct 2026 11:42:12 -0700
Message-ID: <20261028184216.25453-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A LU that is in the ALUA unavailable state on a target port reports
peripheral qualifier 001b in its INQUIRY data. scsi_bus_match() only
matches devices with peripheral qualifier 000b, so if a host scans such
a path, no upper-level driver is ever bound to it. When the target port
later becomes available, nothing binds sd and the path stays unusable
until the device is deleted and rescanned. A host that was already
running when the path became unavailable keeps sd bound, so the result
depends on when the host scanned.

This series fixes that at scan time. The SCSI core reads the ALUA access
state of a device with REPORT TARGET PORT GROUPS before the device is
registered, and matches sd to PQ 001b devices whose access state is
unavailable. This is the same situation as a path in the standby state,
to which sd already binds. The path then stays in the multipath map as a
failed path, and the existing UNIT ATTENTION handling brings it back
when the target port becomes available.

PQ 001b cannot be matched on its own: an unmapped LUN reports it as
well, and some targets report every possible LUN in REPORT LUNS. Binding
sd to all of those would create disks with no backing LU. An unmapped
LUN fails REPORT TARGET PORT GROUPS, so the access state is what tells
the two cases apart.

  1/4 moves submit_rtpg() out of scsi_dh_alua into the SCSI core as
      scsi_report_tpgs(), so the core can read the ALUA state of a
      device itself. No functional change.
  2/4 sends REPORT TARGET PORT GROUPS from scsi_add_lun() for a device
      that reports TPGS support and sets sdev->access_state from the
      descriptor of the target port group of this path.
  3/4 starts a new port group in scsi_dh_alua in the access state the
      core read, rather than active/optimized, so that no I/O is let
      through to an unavailable path before the handler's first RTPG
      completes.
  4/4 matches PQ 001b devices whose access state is unavailable.

This is an alternative to the series that refreshes the INQUIRY data
and reprobes the device on rescan ("scsi: Refresh INQUIRY data and
reprobe on rescan", v8 last posted). That series needs a way to update
the INQUIRY data of a live device and to reprobe it. This one does not
change the INQUIRY data after the device is discovered, and has no
reprobe, so none of the locking and ordering issues that came with
refreshing it.

The INQUIRY data in sysfs is unchanged by this series. It is read and
created once, when the device is discovered, and keeps the peripheral
qualifier reported at that time like the rest of the INQUIRY data. At
any given time that cached peripheral qualifier can be out of sync with
the device, for example after the target port moves between available
and unavailable. An INQUIRY sent to the device returns the current
value, and the access_state attribute shows the current ALUA state.

Brian Bunker (4):
  scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
  scsi: core: Read the ALUA access state when a device is scanned
  scsi: scsi_dh_alua: Start a port group in the scanned access state
  scsi: core: Match ULDs to logical units in the ALUA unavailable state

 drivers/scsi/device_handler/scsi_dh_alua.c | 72 ++++++-----------
 drivers/scsi/scsi_lib.c                    | 52 ++++++++++++
 drivers/scsi/scsi_scan.c                   | 94 ++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  | 14 +++-
 include/scsi/scsi_device.h                 |  3 +
 include/scsi/scsi_proto.h                  |  3 +
 6 files changed, 188 insertions(+), 50 deletions(-)

-- 
2.56.0

