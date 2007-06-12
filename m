From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Mon, 11 Jun 2007 21:59:37 -0400
Message-ID: <466DFE09.3020408@garzik.org>
References: <20070611184146.448266229@intel.com>	<20070611114839.907bcae2.kristen.c.accardi@intel.com>	<20070612011148.GA9808@khazad-dum.debian.net>	<466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <d8jr6oikkcz.fsf@nygaard.ping.uio.no>
Sender: linux-ide-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Dagfinn_Ilmari_Manns=E5ker?= <ilmari@ilmari.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Dagfinn Ilmari Manns=E5ker wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
>=20
>> Henrique de Moraes Holschuh wrote:
>>> On Mon, 11 Jun 2007, Kristen Carlson Accardi wrote:
>>>> Setting		Effect
>>>> ----------------------------------------------------------
>>>> min_power	ALPM is enabled, and link set to enter 		lowest
>>>> power state (SLUMBER) when idle
>>>> 		Hot plug not allowed.
>>>>
>>>> max_performance	ALPM is disabled, Hot Plug is allowed
>>>>
>>>> medium_power	ALPM is enabled, and link set to enter
>>>> 		second lowest power state (PARTIAL) when
>>>> 		idle.  Hot plug not allowed.
>>> Just some food for thought:
>>> If you split it into a enable/disable (0/1) attribute, and a level
>>> attribute
>> on/off doesn't really make sense if the question is "do you favor po=
wer
>> or do you favor performance".......
>=20
> How about just making it a numeric scale with 0 meaning no power savi=
ng
> and then some fixed number of levels (e.g 0-9)?

The original proposal seems far more intuitive than these alternatives.

	Jeff



