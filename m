Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F0123D2A4;
	Mon, 14 Jul 2025 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752484373; cv=none; b=R9lJlS2Hoc/pn70qdmLLE9GQKad/e7xL0YoLvLPnSggGvSt3r/rAe6ySVuyu4i073DT2vNOCgn4MQqLICRSWsk7qHxJhUJmhomMsYH6dTyjq9Tpkf3Z8MPuHGg7x4lmYL1A5vPzleoJw41yImwxKVCQ/VJzdkOAKaukUhJUt+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752484373; c=relaxed/simple;
	bh=6xzJPaygFryc8DCLYakIixZ+C8VGXuJGoenc8w9stus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6pjlkQppQ8lj6aWDhzt7r3rvLdFUeL2Q7P01Sv9yqLJNY8kseRJMGqeGeN1niFW4Ys6ba4fzqWkvRnYUq+FXwoWvjkY9NbSf5kzTFCVZ7JVx+qLDMLNmFYP6KTh0b+vl3EFSs8QWgp1LbegPEv6kOy3ECO2WfpERYZM8CMZ7NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flawful.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (1024-bit key) header.d=flawful.org header.i=@flawful.org header.b=eNhCuqdB; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flawful.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flawful.org header.i=@flawful.org header.b="eNhCuqdB"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55a10c74f31so1064157e87.1;
        Mon, 14 Jul 2025 02:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752484369; x=1753089169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:dkim-signature:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M/kTNmpQefjAtHto56TBeeJ4RIn81/eZMsfsW+BTGuI=;
        b=NB5gfDlZwruhrzUuPygwHoH7pAt8bQbr4e2DFb3sx4ygguZG3p2J74AbH6axJoDMJp
         84bvgw+/YDIWkx/9TlpfMYZ1JGlLC+GcA2tTQqJ5MvWXsg/xniApmJTJ2KzFFS6zd81U
         L/yC1kDSu3Y/rwrsv7JfCyr/hKzuYRaZ9uol8gd/ZmAOyZpwG6FWsBJ1NL5MQnvm9KDf
         sdK7PM8fzBdGTR6kFJ6KyztN2YK0rYPgk6kI0p7taQTusNiVJNwmiuCd62cjKe5m2K5Y
         79ydJbUwBtzhV+stBQGivU8xrX8vIbRLop8UbKKWNgzngsCvZx2wsOmmbbUQw9DLi8AY
         eHUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEQJrt8JJtvOh3f8aZtH206xPfLRdSneblGh1ApXPEm1kw/AOi9MorNsiFoI62LKnCdH79YinMgaab@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxgb1w6JKzMGttwRFEmwEGOtgnW9xZIg5CoVUQUk9nrHN5YRZm
	MjGDblbAhJlU6VHvQ9TdR95M2qNdJ6+VG3DQEOxNAVd6X5nk442Z1W6j
X-Gm-Gg: ASbGncvUXgXCgnQygRrUzUEcxmkxS0H1KQ23Ev3m5bZtk61UC7KBQosNVpqbHWJSF0L
	98qxG0/2Jvh/DSms7VSqqkoErrMHUEbD4mAv77lDAIajoFEe38eB+ayaDp4WhDN148FGrwL/YOl
	oUGlal03tZOnziXrg4AcDJ29RlXy/tpU8YOCZnnjqm249HKC6tTeD0A1yZBrf4YMKMR6/n0TzVW
	fikq3n3K8poCWmE4FO1WELjBnmqaO1sfFjEZJvZOUiPP/u8bPn51BGV1M9RwI54SC7aSr5nlFYX
	TZOMRo0zmmb1g78cAnfkWmvcuFLwE+A0/BAFkJj4bHk9D1xJ+S2KSMIQc/NbjDf7mQ8hDdLuh0b
	5dqiCUKqjaoW66zSdDjqjlAxN9mwegHpkLyby1TZszxIg3JnCeu4=
X-Google-Smtp-Source: AGHT+IFkoboMnDBt3H3vXXqdCHnrm74X11lpyVZl0tTJi8sobREOEbRijG6KqZs1Jb7eiROMkwQg5w==
X-Received: by 2002:a05:6512:68d:b0:553:d122:f8e1 with SMTP id 2adb3069b0e04-55a04645033mr3631255e87.43.1752484368447;
        Mon, 14 Jul 2025 02:12:48 -0700 (PDT)
Received: from flawful.org (c-85-226-250-50.bbcust.telenor.se. [85.226.250.50])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55943b71feasm1888200e87.176.2025.07.14.02.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 02:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
	t=1752484366; bh=6xzJPaygFryc8DCLYakIixZ+C8VGXuJGoenc8w9stus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eNhCuqdBGowy17fzZAcqXCMMxkN+ZV36yJDwRXVLwMRSUS+tkop7GwKhYLTgC/zQW
	 OL9vSZkY+0UvEoVkaaNliYnflO5DbyaJOKliuAT1gZIdYGpe8n7IGyG+PNQ7fpbvgH
	 Ne8Y9spKznHNoim7hW40XIt8mSR73kW5SA6fllqY=
Received: by flawful.org (Postfix, from userid 1001)
	id 7AF982810; Mon, 14 Jul 2025 11:12:46 +0200 (CEST)
Date: Mon, 14 Jul 2025 11:12:46 +0200
From: Niklas Cassel <nks@flawful.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v4 1/3] ata: libata-eh: Remove ata_do_eh()
Message-ID: <aHTKDlu2pXGlnHA3@flawful.org>
References: <20250714005454.35802-1-dlemoal@kernel.org>
 <20250714005454.35802-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714005454.35802-2-dlemoal@kernel.org>

On Mon, Jul 14, 2025 at 09:54:52AM +0900, Damien Le Moal wrote:
> The only reason for ata_do_eh() to exist is that the two caller sites,
> ata_std_error_handler() and ata_sff_error_handler() may pass it a
> NULL hardreset operation so that the built-in (generic) hardreset
> operation for a driver is ignored if the adapter SCR access is not
> available.
> 
> However, ata_std_error_handler() and ata_sff_error_handler()
> modifications of the hardreset port operation can easily be combined as
> they are mutually exclusive. That is, a driver using sata_std_hardreset()
> as its hardreset operation cannot use sata_sff_hardreset() and
> vice-versa.
> 
> With this observation, ata_do_eh() can be removed and its code moved to
> ata_std_error_handler(). The condition used to ignore the built-in
> hardreset port operation is modified to be the one that was used in
> ata_sff_error_handler(). This requires defining a stub for the function
> sata_sff_hardreset() to avoid compilation errors when CONFIG_ATA_SFF is
> not enabled. Furthermore, instead of modifying the local hardreset
> operation definition, set the ATA_LFLAG_NO_HRST link flag to prevent
> the use of built-in hardreset methods for ports without a valid scr_read
> function. This flag is checked in ata_eh_reset() and if set, the
> hardreset method is ignored.
> 
> This change simplifies ata_sff_error_handler() as this function now only
> needs to call ata_std_error_handler().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Niklas Cassel <cassel@kernel.org>
