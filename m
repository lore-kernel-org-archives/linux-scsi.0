Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975249;
	b=zuMChx5NMy2i7MD615caD8iEUj07Nete+t1qm6cGVR4HoBUc+t44FtiNzg1PF5ecRDUf
	 hPehkRxzdxa7qaBBG56ZB0LAIGKi0zAr4dr6gunn0IZR4ofGV0d+LXzn9XIu9AchWPwqG
	 ONFJqClseUJwIZxN6K1e2NfHnpp09Ep1e1KJB/4VRam/JI1hpcisMuOPMFHR9302JeMWn
	 bZt9sTWmxssxPKyMS+suShXafN/O+GfE9zoFlm8WUGBNwhxatXeRQVv8zLSjj4EtG8GhP
	 HY+d8t4jVvXAFCnXFLx4dQHjfSic7+GR135ByKa2GBx/gVawgHKQAe89gnr1UKJjBGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
	b=Vuax1IxxyWZ15McdfuQ0E82x+TwE59Q/8NZs1A0CgAQqC3w+2oNABLHUQ3gar+kiT2d3
	 RPskYgHUGgxPzzEmc4BaqdXrMfn9whLMjiwk/6Ultbz0JdKzF8xpXJ4h38gkS5A3Ad59c
	 kr270wg6hDuNIrfd4y4wWmr6m4cQ+pC5aYm6nzCDj2zK5afKWaM88gatwJ37m3FolwfNd
	 laChZT+uTBAJwCcHfjUA3FxJoUXMzd4Ffjkn2NKwv18x4gB36LwnkgJwnpMT3FjZd5oi6
	 qTctysXu7I6lBocPb1usu0/dX32OD/KXQLCk0M+8o9OPvJMD+RmSOYh6bOvc9vLemZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bvwgy8lj;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895F4606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 895F4606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bvwgy8lj
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ed08b07213so2239795ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975249; x=1795580049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
        b=bvwgy8ljGMYFBI4Ygw0rFbgR0HHy3hEqTsLS9jrO4+33PKYhqXqnBsa55LGMTHZ5LN
         XJc/PVWeRn/u8qd0UHWg6NbTPsht7ffVqPBIK1JouIG0OdAj6zv5CfjvvwL9/tojCDl2
         wvHW54vXtCYf+c41J4YMeUKZCCC067IInN/vZ7L3gE65g2KXidx71QDuxZleeFjKcO+W
         pVu96oFSG1H04tTmve+dSWYLPw5CsTYNShc7BadfAfVkZ+3HbuDf+2JaJsMDup6VBKSf
         /mFSL3oXD/xvkyRvKHcJoFctXpXqyHlAz8DylwM0GIOHEjadcV4wplzCs6KJ1xn1zENy
         ZqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975249; x=1795580049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QqYVAbH+O5Ra0wuswn0xYA0NuJYo04JzgdWyvccojr8=;
        b=jECUkkMXyOIgdTU9rXF7XA5pIVPoY/JkadCDfouPLMCa7k+iW3VEjJEF8B/H8twBSQ
         BM8p/JhUlSwWYn4HdFkGaxx+WamIKg4daqQ9rUknOSXMtGzsSgiwuqPd8tiJT7eEtGd3
         6oo22qr6uW5wyfmZ/7j92QMXw1+rhV09DFDQxqPbBW9tQiCx6ROTDszhybjIGOlJ8EU3
         peF+egpoMIZXeVMK2xxQe1EShHEX7q68GbtmoLEE3ZpXZFWWu6iJJ6iBbxleYg+xXMvt
         J9sfzYfe+ERjpxWznNxhkzKaycH63Vw+CmnmNzvBrMt8yMSeUfsg9dS9R31VAxt9IDos
         Q1lQ==
X-Gm-Message-State: APuU4Z94F27cYsyf9iSpwhkwPm8q5LrDdGG4kAht3jaxsyFVqN1VN5ON
	thpENf1V6GSYaVdSywBEdfG+m+ZX264DvSlZkFzPS7FuvP3G2/Ru+uuw
X-Gm-Gg: AZFdTZedbeVq4Bim/ZDIaMGNJUDp2IijUDxp+4ggTRdup7CILoIAHjwBcbfWwvFSDVN
	0DNQz54/I6nL4MqzqlZv4FfJI68PCAQnlE8V2CcYwSYkQqjAC5oVKEzWY//IlXxpPIehrvARn+g
	taENizNrucPPZaLDO2FZFaQzXcSSx7UkIEj1r4ivInCKz0KZXPE48uMsyH48XMQDKYNQS7N2Wd2
	R0FyvxX2iumTrKqC3+ezhBWjVaEfn8YSCpipUn6dO5f3MxZvuMd5gL6M0z5sasXWqP0l9vyphFv
	ptlgHUKjuPelxdZ+AR9U6730e6ygGFz28fZED7LxGy/6Sf4bKmx/dehVodYdPKz9ju++2cHEVTl
	XUhTJzf3qqKnjwwPv455/BlvsAXPxULuc/ogLXatCcc6mEXlUl+R/3X6wRVkdGQk7qILgW2yUTu
	rkWT5OsCB9cuzxc187xO92n9GqWmqwR97EeZTvT/uBJY1NZNRtttBk+uf2uRZlH3Z/0JcZDsjL6
	ymwdx5GesCoNDOjpwnPXyl3haSoANYQvR/SlgcFXGKbt+oQe1HHWFNJaGvkivDYB8J3ma21ZKxZ
	E621wbGSSIDi0IFiBwzF3A==
X-Received: by 2002:a17:902:c945:b0:2ed:56ee:af84 with SMTP id d9443c01a7336-2eff75693c0mr13558185ad.62.1794975248848;
        Tue, 17 Nov 2026 20:14:08 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:08 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 3/8] scsi: target: reject a short SET TARGET PORT GROUPS list
Date: Wed, 18 Nov 2026 12:13:06 +0800
Message-Id: <20261118041311.19011-4-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
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

SET TARGET PORT GROUPS has a four-byte header followed by four-byte
descriptors. target_emulate_set_target_port_groups() accepts any list
at least four bytes long, then walks a descriptor whenever bytes remain.
A five-byte list can therefore make get_unaligned_be16() read past the
parameter data.

Reject lists whose lengths are not multiples of four before walking
them or changing port group state.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_set_target_port_groups+0x1dc/0x540 [target_core_mod]
  Read of size 2

  target_emulate_set_target_port_groups
  __target_execute_cmd
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c110914b7b78b..22b4c39748704 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -298,9 +298,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
-	if (cmd->data_length < 4) {
-		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			" small\n", cmd->data_length);
+	if (cmd->data_length < 4 || (cmd->data_length & 3)) {
+		pr_warn("SET TARGET PORT GROUPS invalid list length %u\n",
+			cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
