From: Santosh Y <santoshsy@gmail.com>
Subject: Re: scsi: ufs: add support for query requests
Date: Wed, 10 Apr 2013 19:05:28 +0900
Message-ID: <CALMYJDtnJQXZ2jjCteDaTYs4de0941HEyfmdwH0KrC-bkvMttg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: draviv@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vinayak holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>
> This can be done inside the following if condition i.e. if
> (hba->query.descriptor != NULL).
> and change the condition to if (!hba->query.descriptor).
>

I meant to write  if (hba->query.descriptor)...:-)
--
~Santosh
