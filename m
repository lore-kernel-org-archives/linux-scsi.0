Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A52E889C;
	Sat,  2 May 2026 06:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777702057; cv=none; b=ssUUKwN7UmOlhZBApwyFey91AjUDdWL2s+LVVf0wxMY23AewqQtHdBKEU4ao3nxskyBd89fbnLo1qcDMnMu822W71ogBK6mKZO7nJ6O3waHoOuH+cVaNoQr38qvaEITAqCAp8hHqeBbmb+Ie3a3LH5fyl30C71x4wGjodVqXD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777702057; c=relaxed/simple;
	bh=pXOloY3lphl5mElBnI/9UQERARBIL+Gg4okLCV0K5MA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=t3ld6Xu1/oh0T899gJCSt5aODQWKMKzZ+AjIvEK7MY+gVZ0Rs3Gki9pnrNJpYQXOdVD+xf3VV7S1STomVzJ7yLO8kzxD9P8W1t/CuJwoegTQMJGtJE2TYlaxGpmY956OpUt4/WLGskGY3VX0BDzNACzJ9isChzsV5jvyawA3RK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=aB2m0Xw7; arc=none smtp.client-ip=203.205.221.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="aB2m0Xw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777702047; bh=lyJBF7d1vG35Pt9fxGnBS8EczaZilKET3yjPWN0L0Ds=;
	h=From:To:Cc:Subject:Date;
	b=aB2m0Xw7cxUamPBuG4Z/LOE9UYgPx7SySsNH2NbPjhoQlcJ14huCKAyGw+KLZe1hU
	 cJhRl+Trk6Hvy/y1g4v8h5trX+DplNEuHuxUDw03CrY1h8/HyWcbkNDGM6jfIN2TUp
	 bRihHMdj1ixwCWSYyvLxShZWwh5X6u3l7IcdSvGM=
Received: from Lang.smartont.net ([2409:8a44:2312:14e1:56d8:1e1e:3f0b:d0f3])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 1D78B62C; Sat, 02 May 2026 14:07:23 +0800
X-QQ-mid: xmsmtpt1777702043txvzgj6ej
Message-ID: <tencent_818C822F215676B9B14011B88848609BD309@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GbvOGrd8qt9i9yl0joYlV6yEseAkM5sUuNKLagLvGx3N8LuhII1
	 Rj5EMmOgxpp8BrgaN1F8l3SYUXYqtW4aNmeaS62VCCE/KJduqw5bOrMyvHASMW8PRol5WYrMEg7A
	 HijAHqWTaX3IpKBOlU+armGlCVsJO0y8K0JIpI63nEOwvTbXDh+nGz0QPTUnmGJie8MfUsT4hDTx
	 jg4d9cDyq5Fl1lqrCqqmkuNiJ4BgkMo6tPihR+KWPbakx9Rry3rZ34pU6A2/fXb8XtcGce7SilrD
	 i5B0RlUf6sm197wIgTtuPvDIZe8xCCRidZO1g+3HvVaVdXlUsLu/MMw2SWMFddOFMIXFdzTfvO5A
	 WvD8lCztcwohQVOgBOTMRiZOfHL5NHEAjewsnX01iLPHZORIkqEC3W8IkBenFPC+KRgMlg7xAe6k
	 kf4vRPx0NTN81eCbTyMMXE0mi5vUGXMojprnjksHsd8ltUU4Z+Tq3nkdWbwaai011Duf5FwJ0maK
	 LjH/BXzBZ1uDALQMLAo9humBnySnyRO0wri7r/NzegQHin0H8lwcBMnUkMuOmkwEu8P/lfG1Ief2
	 w2+Y7bcEJiLcWgbcbYMDqBQVCnjvGHrIsiA2wxmsOwcIiegBLS7SvH6PdWnoJ0a8NEdnwov5GK9/
	 YE19s4H9Jf6WanSfR26Lz/Z7u8tJIxzP7qKa0U1b2+V/arxKiRnVlWeh8wBi5AN5wvbzCpyt4bzk
	 vEVia+nsjpNrsRJlCWRYZX/eHCLPSBk6WqwzrCdAuwTdzXkVe6O0J7rE4CVXDIddMb3iUG/06RTs
	 PTkyqsXMzBtA1H6LZp6WPVt+95TR7TYtO+df22KYl3HP9yggna6GbcnyqIbhdiDbm1qfp7/Hgltv
	 IsBnaoqUGqyp1PYuLMKsKxcWDvmROdA4y8PPdxCphg+DfPggtEWqGI04XadrdlZVJiLnuBG9R3Da
	 AejxFwX+PYqnfmYKX2kur9rUjE7WWrcBUe/xhPOB7uTBaXQXT1/9BhF25OB7IeOK7jZyTRqQN/Wr
	 6AomeKMD8I53Qlxl4y4XEutbwcZbu2T/94KIiOwxwKq8MQGRlLdfCUGhAbgv6tb0JAEdOq31QYae
	 rhDzzJZ1i89SQo2DBpruC6fpRzUZW/AnCbz5SKZ4HIorH80gmuhInjXt/kkSwbTuUhyvr2
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Wang Zihan <jiyu03@qq.com>
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Wang Zihan <jiyu03@qq.com>
Subject: [PATCH v2] scsi: st: fix typo in documentation
Date: Sat,  2 May 2026 14:07:03 +0800
X-OQ-MSGID: <20260502060703.142663-1-jiyu03@qq.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "form" to "from" in drive buffers description.

Signed-off-by: Wang Zihan <jiyu03@qq.com>
---
 Documentation/scsi/st.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
index b4a092faa..539ff06da 100644
--- a/Documentation/scsi/st.rst
+++ b/Documentation/scsi/st.rst
@@ -93,7 +93,7 @@ optionally written. In both cases end of data is signified by
 returning zero bytes for two consecutive reads.
 
 Writing filemarks without the immediate bit set in the SCSI command block acts
-as a synchronization point, i.e., all remaining data form the drive buffers is
+as a synchronization point, i.e., all remaining data from the drive buffers is
 written to tape before the command returns. This makes sure that write errors
 are caught at that point, but this takes time. In some applications, several
 consecutive files must be written fast. The MTWEOFI operation can be used to
-- 
2.54.0

