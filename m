Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8528427E05E
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 07:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071510; cv=none; b=eM1B7KHwsyg8EFFSMncJk0MAkhkzM1cMZhMgoE5JIcMpi4ipi7yEX/8g1XBrS4Cco+cHR6R/WPx8TvjiN5SjCuOWEwnW0xRlqQ46LgSPAFU++VN7L0sk3jKxwb7Q92x39Dcg5A0E2kw1QCOTz1R8UITiZM0c9TCNHcUnCS8fuwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071510; c=relaxed/simple;
	bh=75rO32DYnWfh+6Moc/iat2lWnh9dn/TYGo9H8GWor48=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=t1z5T9owrKn4J1leg7YRPamqaDbygY5qwatST3+mS4u+mgHJYb6zxG4Suq5VsIFoDRvQ34aNsJ2fJdwmzxadOJ2HxRCjcA0jTsgj3RQr1rpZzkiRd3Kq+8DWsybcO6rdZdSUKvp5UviDsArChQ58WWHdUlOl5U3P2CcI1opDuSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id E45242C06659;
	Wed, 13 Aug 2025 09:43:22 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id DDFD737D921; Wed, 13 Aug 2025 09:43:22 +0200 (CEST)
Date: Wed, 13 Aug 2025 09:43:22 +0200
From: Lukas Wunner <lukas@wunner.de>
To: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>
Cc: linux-scsi@vger.kernel.org
Subject: Bouncing maintainer address for Emulex/Broadcom LPFC SCSI driver
Message-ID: <aJxCGi-am1N_UcVd@wunner.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear James, Dear Ram,

The e-mail address of Dick Kennedy listed in this MAINTAINERS entry ...

    EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER
    M:	James Smart <james.smart@broadcom.com>
    M:	Dick Kennedy <dick.kennedy@broadcom.com>
    L:	linux-scsi@vger.kernel.org
    S:	Supported
    W:	http://www.broadcom.com
    F:	drivers/scsi/lpfc/

... is bouncing:

    Your message wasn't delivered to dick.kennedy@broadcom.com because the address couldn't be found, or is unable to receive mail.
    Learn more here: https://support.google.com/mail/?p=NoSuchUser
    The response was:
    The email account that you tried to reach does not exist. Please try double-checking the recipient's email address for typos or unnecessary spaces.

Please consider replacing the bouncing address in MAINTAINERS at your
earliest convenience.

Thanks!

Lukas
